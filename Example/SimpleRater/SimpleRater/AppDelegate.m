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

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DZNAppRater setAppIdentifier:YOUR_APP_IDENTIFIER];
    [DZNAppRater setTrackingInterval:3];
    [DZNAppRater setLogEnabled:YES];
    [DZNAppRater startTracking];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStyleDone target:self action:@selector(requestRate:)];
    viewController.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Rate" style:UIBarButtonItemStyleDone target:self action:@selector(rateApp:)];
    viewController.navigationItem.rightBarButtonItem = rightButton;
    
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)requestRate:(id)sender
{
    [DZNAppRater requestRating];
}

- (void)rateApp:(id)sender
{
    [DZNAppRater openStore];
}

@end
