//
// Created by Ian Dundas on 15/04/2014.
//

@import UIKit;

@import Foundation;

/*
    A glorified singleton hash of a service tokens mapped to Boolean Valid/Not Valid.
    Service tokens are usually just the endpoint URL

    Use this to keep track of whether an endpoint needs a network refresh or not.

    Note: All endpoints are marked invalid when app goes to background */

@interface IDBasicCacheValidator : NSObject

+ (instancetype)sharedManager;

- (void)resetCache;
- (void)invalidateCacheForToken:(NSString *)token;

- (BOOL)isCacheValidForToken:(NSString *)token;
- (void)setCacheIsValidForToken:(NSString *)token;
@end