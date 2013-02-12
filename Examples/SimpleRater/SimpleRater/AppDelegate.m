//
//  AppDelegate.m
//  SimpleRater
//
//  Created by Ignacio Romero Zurbuchen on 10/23/12.
//  Copyright (c) 2012 DZEN. All rights reserved.
//

#import "AppDelegate.h"
#import "DZAppRater.h"

#define YOUR_APP_IDENTIFIER 000000000

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    [DZAppRater setAppIdentifier:YOUR_APP_IDENTIFIER];
    [DZAppRater setRaterInterval:3];
    [DZAppRater startTracking];
    
    return YES;
}

@end
