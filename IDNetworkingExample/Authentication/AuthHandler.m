//
// Created by Ian Dundas on 13/02/14.
//

#import <FXKeychain/FXKeychain.h>
#import "AuthHandler.h"
#import "NSManagedObject+ActiveRecord.h"
#import "IDBasicCacheValidator.h"
#import "Consts.h"
#import "CoreDataManager+extensions.h"
#import "GVUserDefaults+defaults.h"

@interface AuthHandler ()
- (void)wipeCoreDataStore;

- (void)wipeUserDefaults;

- (void)wipeKeyChain;
@end

@implementation AuthHandler

+ (AuthHandler *)sharedManager {
    static AuthHandler *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

// checks if we're still within the valid-until date of last login
- (BOOL)isLoggedIn {
    return [FXKeychain defaultKeychain][KEYCHAIN_KEY_ACCESSTOKEN] && [FXKeychain defaultKeychain][KEYCHAIN_KEY_ACCESSTOKEN]!= [NSNull null];
}

- (void)saveLoginWithAccessToken:(NSString *)accessToken
                    refreshToken:(NSString *)refreshToken
                      expiryDate:(NSDate *)expiryDate {

    [FXKeychain defaultKeychain][KEYCHAIN_KEY_ACCESSTOKEN] = accessToken;
    [FXKeychain defaultKeychain][KEYCHAIN_KEY_REFRESHTOKEN] = refreshToken;
}

- (void)clearLogin {
    [self wipeCoreDataStore];
    [self wipeKeyChain];
    [self resetUserPreferences];
}

-(void) resetUserPreferences{
    [self wipeUserDefaults];
    [[GVUserDefaults standardUserDefaults] setHasCompletedFirstInstall:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)wipeCoreDataStore {
    // clear cache tracker as is now invalid
    [[IDBasicCacheValidator sharedManager] resetCache];

    // Delete .sqlite database and create a new one:
    [[CoreDataManager sharedManager] resetDatastore];
}

- (void)wipeUserDefaults {
    // http://stackoverflow.com/a/24709543/349364
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)wipeKeyChain {
    [FXKeychain defaultKeychain][KEYCHAIN_KEY_ACCESSTOKEN] = [NSNull null]; // can't set to nil
    [FXKeychain defaultKeychain][KEYCHAIN_KEY_REFRESHTOKEN] = [NSNull null];// can't set to nil
}
@end