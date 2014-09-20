//
// Created by Ian Dundas on 12/02/14.
//

@import Foundation;
#import "IDBaseWebService.h"


@interface OAuthLoginService : IDBaseWebService
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@end