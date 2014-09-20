//
// Created by Ian Dundas on 13/02/14.
//

@import Foundation;
#import "GVUserDefaults.h"

@interface GVUserDefaults (defaults)

// used as a flag to detect reinstalls, so can wipe KeyChain (which is persisted between installs) & log user out.
@property(nonatomic) BOOL hasCompletedFirstInstall;
- (NSDictionary *)setupDefaults;
@end