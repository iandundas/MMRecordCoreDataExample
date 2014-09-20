//
//  AppDelegate.m
//  IDNetworkingExample
//
//  Created by Ian Dundas on 19/09/2014.
//  Copyright (c) 2014 Ian Dundas Freelance. All rights reserved.
//


#import <ObjectiveRecord/CoreDataManager.h>
#import "AppDelegate.h"
#import "IDSearchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [CoreDataManager sharedManager].modelName = @"Model";
    [[CoreDataManager sharedManager] useInMemoryStore];

    self.baseViewController= [[UINavigationController alloc]
        initWithRootViewController:[[IDSearchViewController alloc] init]
    ];
    self.window.rootViewController = self.baseViewController;

    [self.window makeKeyAndVisible];
    return YES;
}


@end