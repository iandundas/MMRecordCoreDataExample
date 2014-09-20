//
// Created by @id
// Based on JRT's "Nice Web Services" manifesto:
//      http://commandshift.co.uk/blog/2014/01/02/nice-web-services/

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Reachability/Reachability.h>
#import "IDBaseWebService.h"
#import "IDConfiguration.h"
#import "AuthHandler.h"
#import "OAuthRefreshTokenService.h"
#import "FXKeychain.h"
#import "Consts.h"
#import <libextobjc/EXTScope.h>

NSString *const IDNetworkErrorDomain = @"uk.co.iandundas.error.networkerror";
NSString *const IDServiceErrorDomain = @"uk.co.iandundas.error.serviceerror";

typedef void(^IDWebServiceSuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void(^IDWebServiceFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);

@interface IDBaseWebService ()
@property(nonatomic) BOOL hasTriedToRefresh;
@property(nonatomic, strong) OAuthRefreshTokenService *refreshTokenService;
- (NSURL *)requestURL;
@end

@implementation IDBaseWebService
#pragma mark - Override:

// @override
+ (NSString *)endpoint {
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}
// can usually be left alone - see .h file for more info
-(NSString *) instanceEndpoint{
    return [self.class endpoint];
}

// @override
- (NSMutableDictionary *)parameters {
    // Any common parameters to all services to be implemented here. Subclasses call super and add their own.
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    return parameters;
}

// @override
- (id)responseObjectFromServiceResponse:(id)serviceResponse {
    // default behaviour is just to return the object. Subclass to transform object.
    return serviceResponse;
}

// @override
- (NSString *)httpVerb {
    return @"GET";
}

/* ========= PRIVATE ========= */
#pragma mark - Networking

- (void)configureRequest:(NSMutableURLRequest *)request {

    /* Example usage: */
//    NSString *access_token = [FXKeychain defaultKeychain][KEYCHAIN_KEY_ACCESSTOKEN];
//
//    if (!access_token || access_token.class == NSNull.class)
//        access_token= @"";
//
//    [request setValue:access_token forHTTPHeaderField:@"Authorization"];
//    [request setValue:[IDConfiguration APIKey] forHTTPHeaderField:@"X-Api-Key"];
}

- (NSURL *)requestURL {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [IDConfiguration APIEndpoint], [self instanceEndpoint]];
    return [NSURL URLWithString:urlString];
}


- (NSError *)serviceLevelErrorFromServiceResponse:(id)serviceResponse {
    // If the API served up any sort of errors in the response, detect and return them here.
    // Override to detect specific cases, or implement general check here.
    if (!serviceResponse) {
        return [NSError
                errorWithDomain:IDNetworkErrorDomain
                           code:404
                       userInfo:@{NSLocalizedDescriptionKey : @"Received a blank response from server"}
        ];
    }
    else if ([serviceResponse isKindOfClass:NSDictionary.class]) {
        NSDictionary *serviceResponse_ = (NSDictionary *) serviceResponse;
        if (serviceResponse_[@"error"]) {

            NSNumber *code = serviceResponse_[@"code"] ? serviceResponse_[@"code"] : @(400);

            if (serviceResponse_[@"error_description"]) {
                return [NSError
                        errorWithDomain:IDNetworkErrorDomain
                                   code:code.intValue
                               userInfo:@{NSLocalizedDescriptionKey : serviceResponse_[@"error_description"] }
                ];
            }
            else {
                return [NSError
                        errorWithDomain:IDNetworkErrorDomain
                                   code:code.intValue
                               userInfo:@{NSLocalizedDescriptionKey : @"Unknown error whilst parsing response"}
                ];
            }
        }
    }
//    NSLog(@"Service Response: %@", serviceResponse);
    return nil;
}

- (BOOL)serviceAllowsTokenRefresh {
    return YES;
}

// @override
- (AFHTTPRequestSerializer *)requestSerializer {
    return [AFHTTPRequestSerializer serializer];
}

// @override
- (AFHTTPResponseSerializer *)responseSerializer {
    return [AFJSONResponseSerializer serializer];
}

- (AFHTTPRequestOperationManager *)session {
    if (!_session) {
        _session = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[IDConfiguration APIEndpoint]]];

        // Only load the security policy for the appstore build
        if ([IDConfiguration isProduction])
            _session.securityPolicy = [self securityPolicy];
        _session.requestSerializer = [self requestSerializer];
        _session.responseSerializer = [self responseSerializer];
    }
    return _session;
}

- (AFSecurityPolicy*) securityPolicy
{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setValidatesDomainName:YES];

//    [securityPolicy setValidatesCertificateChain:NO];
//    [securityPolicy setPinnedCertificates:validCerts];
//    [securityPolicy setSSLPinningMode:AFSSLPinningModePublicKey];

    return securityPolicy;
}

- (void)startWithCompletion:(TTWebServiceCompletionBlock)completionBlock {
    // Set up a basic completion block to prevent having to check it all the time later
    if (!completionBlock) {
        completionBlock = ^(id response, NSError *error) {
        };
    }

    if (![[self.class reachability] isReachable]){
        NSError *reachabilityError = [NSError errorWithDomain:IDNetworkErrorDomain code:6 userInfo:@{
            NSLocalizedDescriptionKey : @"Het is geen netwerkverbinding beschikbaar"
        }];

        completionBlock (nil, reachabilityError);
        return;
    }


    @weakify(self)
    IDWebServiceSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseJSON) {
        @strongify(self)

        // Step: Check response against subclass-implementation of serviceLevelErrorFromServiceResponse:
        //   This will ensure that we didn't get any funky not-helpful-at-all JSON messages from the server
        NSError *serviceLevelError = [self serviceLevelErrorFromServiceResponse:responseJSON];
        if (serviceLevelError) {
            dispatch_async (dispatch_get_main_queue(), ^{
                completionBlock (nil, serviceLevelError);
            });
            return;
        }

        // Step: any response-massaging, again dependant on subclass-implementation
        //    MMRecord-style services don't need this step, so have a blank subclass method implementation
        id processedResponse = [self responseObjectFromServiceResponse:responseJSON];

        // Step: we now have our response, time to pass it to the completion block.
        dispatch_async (dispatch_get_main_queue(), ^{
            completionBlock (processedResponse, nil);
        });

        [self setHasTriedToRefresh:NO];
    };

    IDWebServiceFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self)
        if (error) {
            NSError *returnError = [self errorFromOperation:operation withError:error];
            NSLog (@"IDBaseWebService-processed error: '%@'", error);

            if (returnError.code == 401 && !self.hasTriedToRefresh && self.serviceAllowsTokenRefresh) {
                self.hasTriedToRefresh = YES;

                self.refreshTokenService.refreshToken = [FXKeychain defaultKeychain][KEYCHAIN_KEY_REFRESHTOKEN];
                [self.refreshTokenService startWithCompletion:^(id response, NSError *refreshTokenError) {

                    if (refreshTokenError || !response) {
                        // We couldn't get a new access token:
                        dispatch_async (dispatch_get_main_queue(), ^{

                            completionBlock (nil, returnError);
                        });
                    }
                    else {

                        NSString *accessToken = response[@"access_token"];
                        NSString *refreshToken = response[@"refresh_token"];
                        NSString *expiresInSeconds = response[@"expires_in"];

                        if (accessToken && refreshToken && expiresInSeconds) {
                            NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:expiresInSeconds.doubleValue];

                            // OK, we've refreshed access details, save login:
                            [[AuthHandler sharedManager]
                                    saveLoginWithAccessToken:accessToken
                                                refreshToken:refreshToken
                                                  expiryDate:expiresDate];

                            // Let's try request again, with our new access token.
                            [self startWithCompletion:completionBlock];
                        }
                        else {
                            // failed, just return with original error:
                            dispatch_async (dispatch_get_main_queue(), ^{
                                completionBlock (nil, returnError);
                            });

                            [self setHasTriedToRefresh:NO];
                        }
                    }
                }];

            }
            else {
                [self setHasTriedToRefresh:NO];

                // Our request failed, bubble up an error:
                dispatch_async (dispatch_get_main_queue(), ^{
                    completionBlock (nil, returnError);
                });
                return;
            }
        }
    };


    // Instantiate a request object:
    NSMutableURLRequest *request = [[[self session] requestSerializer]
            requestWithMethod:[self httpVerb]
                    URLString:[self.requestURL absoluteString]
                   parameters:[self parameters]
                        error:nil];

    [self configureRequest:request];

    [[self session].operationQueue addOperation:[
            [self session] HTTPRequestOperationWithRequest:request
                                                   success:successBlock
                                                   failure:failureBlock]
    ];
}

#pragma mark - Reachability
+ (Reachability *)reachability{
    static Reachability *ReachabilityChecker;

    static dispatch_once_t initReachability;
    dispatch_once(&initReachability, ^{
        ReachabilityChecker = [Reachability reachabilityWithHostname:@"google.com"];
    });

    return ReachabilityChecker;
}


#pragma mark Handling Responses:

- (NSError *)errorFromOperation:(AFHTTPRequestOperation *)operation withError: (NSError *)error {
    NSString *description = error.localizedDescription; //@"Could not connect to service. Please check your network settings.";

    // Use the HTTP status code as error code if available else fallback to the AFNetworking error code
    int code = operation ? [operation.response statusCode] : error.code;

    if ([description containsString:@"unauthorized (401)"]) {
        code = 401; //AFNetworking override
    }
    return [NSError errorWithDomain:IDNetworkErrorDomain code:code userInfo:@{ NSLocalizedDescriptionKey : description }];
}

-(OAuthRefreshTokenService *)refreshTokenService{
    if (!_refreshTokenService){
        _refreshTokenService= OAuthRefreshTokenService.new;
    }
    return _refreshTokenService;
}

@end