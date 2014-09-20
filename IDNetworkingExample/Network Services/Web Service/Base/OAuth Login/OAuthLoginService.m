//
// Created by Ian Dundas on 12/02/14.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "OAuthLoginService.h"
#import "IDConfiguration.h"

@implementation OAuthLoginService {
    AFHTTPRequestOperationManager *_oAuthSession; // different to the normal static one as uses a different requestSerializer
}

- (NSMutableDictionary *)parameters {
    NSMutableDictionary *params = [super parameters];

    params[@"grant_type"] = @"password";
    params[@"username"] = self.username;
    params[@"password"] = self.password;
    params[@"client_id"] = [IDConfiguration ClientId];
    params[@"client_secret"] = [IDConfiguration ClientSecret];

    return params;
}

- (NSString *)httpVerb {
    return @"POST";
}

+ (NSString *)endpoint {
    return @"oauth_nl/token";
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



@end