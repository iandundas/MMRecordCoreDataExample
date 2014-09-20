@import Foundation;
#import "AFMMRecordResponseSerializationMapper.h"

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestSerializer;
@class AFHTTPResponseSerializer;
@class Reachability;

extern NSString *const IDNetworkErrorDomain;
extern NSString *const IDServiceErrorDomain;

typedef void(^TTWebServiceCompletionBlock) (id response, NSError *error);

@interface IDBaseWebService : NSObject {
@protected
    AFHTTPRequestOperationManager *_session;
}


- (AFHTTPRequestSerializer *)requestSerializer;

- (AFHTTPResponseSerializer *)responseSerializer;

// Starts the service
- (void)startWithCompletion:(TTWebServiceCompletionBlock)completionBlock;

+ (Reachability *)reachability;

// Configure the request before it is called
- (void)configureRequest:(NSMutableURLRequest *)request;

// Returns a dictionary containing the parameters used for the web service. Subclasses should override this method to add additional parameters to the default ones
- (NSMutableDictionary *)parameters;

// Returns the API endpoint of the specific service. Subclasses override this to provide the specific endpoint.
+ (NSString *)endpoint;

// Sometimes the endpoint needs to be dynamic - in this case this override point is provided.
// Returns result of static method by default.
- (NSString *)instanceEndpoint;

// return @"GET", @"POST", etc.
- (NSString *)httpVerb;

// Some service cannot be refreshed, for example services which do not require to be authorised,
// For example the OAuthLoginService or external services.
-(BOOL)serviceAllowsTokenRefresh;

// Creates a response object with named parameters which is returned in the completion block instead of a dictionary
- (id)responseObjectFromServiceResponse:(id)serviceResponse;

// Creates an error object from a valid JSON response, if applicable.
- (NSError *)serviceLevelErrorFromServiceResponse:(id)serviceResponse;

@end
