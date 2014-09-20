//
//  IDConfiguration.m
//  Created by Ian Dundas

#import <ObjectiveSugar/NSString+ObjectiveSugar.h>
#import "IDConfiguration.h"

#define IDConfigurationAPIEndpoint @"API_BASE_URL"
#define IDConfigurationOAuthEndpoint @"OAUTH_URL"
#define IDConfigurationAPIKey @"API_KEY"
#define IDConfigurationClientId @"CLIENT_ID"
#define IDConfigurationClientSecret @"CLIENT_SECRET"

@interface IDConfiguration ()

@property(copy, nonatomic) NSString *configuration;
@property(nonatomic, strong) NSDictionary *variables;

@end

@implementation IDConfiguration

#pragma mark -
#pragma mark Shared Configuration

+ (IDConfiguration *)sharedConfiguration {
    static IDConfiguration *_sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _sharedConfiguration = [[self alloc] init];
    });

    return _sharedConfiguration;
}

#pragma mark -
#pragma mark Private Initialization

- (id)init {
    self = [super init];

    if (self) {
        // Fetch Current Configuration
        NSBundle *mainBundle = [NSBundle mainBundle];
        self.configuration = [mainBundle infoDictionary][@"Configuration"];

        // Load Configurations
        NSString *path = [mainBundle pathForResource:@"Configuration" ofType:@"plist"];
        NSDictionary *configurations = [NSDictionary dictionaryWithContentsOfFile:path];

        // Load Variables for Current Configuration
        self.variables = configurations[self.configuration];
    }

    return self;
}

#pragma mark -

+ (NSString *)configuration {
    return [[IDConfiguration sharedConfiguration] configuration];
}

+ (IDEnvironment)environment {
    NSString *envString = [IDConfiguration configuration];

    if ([envString isEqualToString:@"Production 4G"])
        return IDEnvironmentProduction4G;
    if ([envString isEqualToString:@"Development 4G"])
        return IDEnvironmentDevelopment4G;

    return IDEnvironmentDevelopment4G;
}

+ (BOOL)isDevelopment {
    return [IDConfiguration environment] == IDEnvironmentDevelopment4G;
}

+ (BOOL)isProduction {
    return [IDConfiguration environment] == IDEnvironmentProduction4G;
}

#pragma mark -

+ (NSString *)APIEndpoint {
    IDConfiguration *sharedConfiguration = [IDConfiguration sharedConfiguration];

    if (sharedConfiguration.variables) {
        return (sharedConfiguration.variables)[IDConfigurationAPIEndpoint];
    }

    return nil;
}

+ (NSString *)OAuthEndpoint {
    IDConfiguration *sharedConfiguration = [IDConfiguration sharedConfiguration];

    if (sharedConfiguration.variables) {
        return (sharedConfiguration.variables)[IDConfigurationOAuthEndpoint];
    }

    return nil;
}

+ (NSString *)ClientId {
    IDConfiguration *sharedConfiguration = [IDConfiguration sharedConfiguration];

    if (sharedConfiguration.variables) {
        return (sharedConfiguration.variables)[IDConfigurationClientId];
    }

    return nil;
}

+ (NSString *)ClientSecret {
    IDConfiguration *sharedConfiguration = [IDConfiguration sharedConfiguration];

    if (sharedConfiguration.variables) {
        return (sharedConfiguration.variables)[IDConfigurationClientSecret];
    }

    return nil;
}

+ (NSString *)APIKey {
    IDConfiguration *sharedConfiguration = [IDConfiguration sharedConfiguration];

    if (sharedConfiguration.variables) {
        return (sharedConfiguration.variables)[IDConfigurationAPIKey];
    }

    return nil;
}

+ (NSString *)versionString {

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = infoDict[@"CFBundleShortVersionString"]; // example: 1.0.0
    NSNumber *buildNumber = infoDict[@"CFBundleVersion"]; // example: 42

    return NSStringWithFormat (@"%@ (%@)", appVersion, buildNumber);
}


@end