//
//  AppDelegate.m
//  SimpleRater
//
//  Created by Ignacio Romero Zurbuchen on 10/23/12.
//  Copyright (c) 2012 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "DZNAppRater.h"

#define YOUR_APP_IDENTIFIER 000000000

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    [DZNAppRater setAppIdentifier:YOUR_APP_IDENTIFIER];
    [DZNAppRater setTrackingInterval:3];
    [DZNAppRater startTracking];
    
    return YES;
}

@end
