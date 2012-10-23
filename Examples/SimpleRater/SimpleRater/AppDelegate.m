//
//  AppDelegate.m
//  SimpleRater
//
//  Created by Ignacio on 10/23/12.
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
    rootViewController.view.backgroundColor = [UIColor grayColor];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    [[DZAppRater sharedInstance] setAppIdentifier:YOUR_APP_IDENTIFIER];
    [[DZAppRater sharedInstance] setRaterInterval:3];
    [[DZAppRater sharedInstance] startTracking];
    
    return YES;
}

@end
