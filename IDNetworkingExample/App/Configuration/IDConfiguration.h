//
//  IDConfiguration.h
//  Created by Ian Dundas

@import Foundation;

typedef enum : NSUInteger {
    IDEnvironmentDevelopment4G,
    IDEnvironmentProduction4G,
} IDEnvironment;

@interface IDConfiguration : NSObject

#pragma mark -

+ (NSString *)configuration;

+ (IDEnvironment)environment;

+ (BOOL)isDevelopment;

+ (BOOL)isProduction;

+ (NSString *)APIEndpoint;

+ (NSString *)OAuthEndpoint;

+ (NSString *)ClientId;

+ (NSString *)ClientSecret;

+ (NSString *)APIKey;

+ (NSString *) versionString;

@end