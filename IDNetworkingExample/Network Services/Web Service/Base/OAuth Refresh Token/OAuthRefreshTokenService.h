//
// Created by Ian Dundas on 14/02/14.
//

@import Foundation;
#import "IDBaseWebService.h"


@interface OAuthRefreshTokenService : IDBaseWebService
@property(nonatomic, strong) NSString *refreshToken;
@end