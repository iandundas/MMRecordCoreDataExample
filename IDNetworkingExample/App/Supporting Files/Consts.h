#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// http://stackoverflow.com/a/12447113/349364
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

// obviously doesn't apply if we ever add landscape
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width // %f
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height // %f

#define KEYCHAIN_KEY_REFRESHTOKEN @"KEYCHAIN_KEY_REFRESHTOKEN"
#define KEYCHAIN_KEY_ACCESSTOKEN @"KEYCHAIN_KEY_ACCESSTOKEN"