//
// Created by Ian Dundas on 15/04/2014.
//

#import "IDBasicCacheValidator.h"


@interface IDBasicCacheValidator ()
@property(nonatomic, strong) NSMutableDictionary *cacheValidator;
@end

@implementation IDBasicCacheValidator {
}

+ (instancetype)sharedManager {
    static IDBasicCacheValidator *singleton;
    static dispatch_once_t singletonToken;
    dispatch_once (&singletonToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (IDBasicCacheValidator *)init {
    if (self = [super init]) {
        _cacheValidator = NSMutableDictionary.new;

        [[NSNotificationCenter defaultCenter]
                addObserver:self
                   selector:@selector (appDidEnterBackground)
                       name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)appDidEnterBackground {
    [self resetCache];
}

- (void)resetCache {
    NSLog (@"Invalidating cache");
    [self.cacheValidator removeAllObjects];
}

- (BOOL)isCacheValidForToken:(NSString *)token {
    return self.cacheValidator[token] != nil;
}

- (void)setCacheIsValidForToken:(NSString *)token {
    if (token) {
        self.cacheValidator[token] = [NSDate date];
    }
}

-(void)invalidateCacheForToken: (NSString *)token{
    if(token){
        [self.cacheValidator removeObjectForKey:token];
    }
}

@end