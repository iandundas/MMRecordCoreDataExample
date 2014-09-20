//
// Created by Ian Dundas on 13/02/14.
//

@import Foundation;

@interface AuthHandler : NSObject
+ (AuthHandler *)sharedManager;

- (BOOL)isLoggedIn;
- (void)clearLogin;

- (void)saveLoginWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken expiryDate:(NSDate *)expiryDate;
@end