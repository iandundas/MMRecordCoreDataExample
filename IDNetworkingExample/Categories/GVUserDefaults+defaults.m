//
// Created by Ian Dundas on 13/02/14.
//

#import "GVUserDefaults+defaults.h"

@implementation GVUserDefaults (defaults)
@dynamic hasCompletedFirstInstall;
@dynamic bundleDetailsLastUpdated;
@dynamic customerDetailsLastUpdated;
@dynamic customerType;
@dynamic productDetailsLastUpdated;
@dynamic invoiceListLastUpdated;
@dynamic invoiceDetailsLastUpdated;
@dynamic invoiceBundleUsageLastUpdated;
@dynamic unbilledUsageDetailLastUpdated;
@dynamic gaAccepted;
@dynamic hasShownMenuHintOverlay;
@dynamic hasShownPullToRefreshHintOverlay;
@dynamic hasShownTutorial;
@dynamic shouldShowConfirmUserDetailsScreenOnNextSuccessfulLogin;
@dynamic hasGrantedGPSPermission;
@dynamic hasGrantedRemoteNotificationPermission;

- (NSDictionary *)setupDefaults {
    return @{
            @"hasCompletedFirstInstall" : @NO,
    };
}
@end