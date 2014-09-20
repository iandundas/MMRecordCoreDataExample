//
// Created by Ian Dundas on 14/02/14.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "OAuthRefreshTokenService.h"
#import "IDConfiguration.h"


@implementation OAuthRefreshTokenService {
    AFHTTPRequestOperationManager *_oAuthSession; // different to the normal static one as uses a different requestSerializer
}

#pragma mark Configure Endpoint

- (NSMutableDictionary *)parameters {
    NSMutableDictionary *params = [super parameters];

    params[@"grant_type"] = @"refresh_token";
    params[@"refresh_token"] = self.refreshToken?self.refreshToken : @"";
    params[@"client_id"] = [IDConfiguration ClientId];
    params[@"client_secret"] = [IDConfiguration ClientSecret];

    return params;
}

+ (NSString *)endpoint {
    return @"oauth_nl/token";
}

- (NSString *)httpVerb {
    return @"POST";
}
- (BOOL)serviceAllowsTokenRefresh {
    return NO;
}

- (void)configureRequest:(NSMutableURLRequest *)request {

    NSMutableDictionary *headers = request.allHTTPHeaderFields.mutableCopy;
    [headers setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headers setObject:[IDConfiguration APIKey] forKey:@"X-Api-Key"];
    [request setAllHTTPHeaderFields:headers];

//    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark Session

- (AFHTTPRequestOperationManager *)session {
    // different to the normal static one (see parent class) as uses the default request/response serializers instead
    if (!_oAuthSession) {
        _oAuthSession = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[IDConfiguration APIEndpoint]]];
    };
    return _oAuthSession;
}
@end