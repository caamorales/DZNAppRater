//
//  DZAppRater.m
//  SimpleRater
//
//  Created by Ignacio Romero Zurbuchen on 10/23/12.
//  Copyright (c) 2012 DZEN. All rights reserved.
//

#import "DZAppRater.h"

static NSString * const kRaterIdentifier = @"RaterIdentifier";
static NSString * const kRaterInterval = @"RaterInterval";
static NSString * const kRaterDidRate = @"RaterDidRate";
static NSString * const kRaterSession = @"RaterSession";

@interface DZAppRater ()
@end

@implementation DZAppRater

#pragma mark - Getter Methods

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSUInteger)identifier
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kRaterIdentifier] integerValue];
}

+ (NSUInteger)interval
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kRaterInterval] integerValue];
}


#pragma mark - Setter Methods

+ (void)setAppIdentifier:(NSUInteger)identifier
{
    [DZAppRater setUserDefaultsValue:[NSNumber numberWithInteger:identifier] forKey:kRaterIdentifier];
}

+ (void)setRaterInterval:(NSUInteger)interval
{
    [DZAppRater setUserDefaultsValue:[NSNumber numberWithInteger:interval] forKey:kRaterInterval];
}

+ (void)resetTracking
{
    [DZAppRater setUserDefaultsValue:[NSNumber numberWithInteger:0] forKey:kRaterSession];
    [DZAppRater setUserDefaultsValue:[NSNumber numberWithBool:NO] forKey:kRaterDidRate];
}

+ (void)userDidRateApp
{
    [DZAppRater setUserDefaultsValue:[NSNumber numberWithBool:YES] forKey:kRaterDidRate];
}

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)aKey
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:aKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - DZAppRater Methods

+ (void)startTracking
{
    BOOL didRateApp = [[[NSUserDefaults standardUserDefaults] objectForKey:kRaterDidRate] boolValue];
    
    NSLog(@"did Rate App already ? %@", didRateApp ? @"Yes" : @"No");
    
    if (!didRateApp)
    {
        int session = [[[NSUserDefaults standardUserDefaults] objectForKey:kRaterSession] integerValue];
        session++;
        
        NSLog(@"Session # %d",session);
        
        if (session % [DZAppRater interval] == 0)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:RaterAlertButtonOk
                                                                message:RaterAlertMessage
                                                               delegate:self
                                                      cancelButtonTitle:RaterAlertButtonNo
                                                      otherButtonTitles:RaterAlertButtonOk, RaterAlertButtonLater, nil];
            [alertview show];
        }

        [DZAppRater setUserDefaultsValue:[NSNumber numberWithInteger:session] forKey:kRaterSession];
    }
}

+ (void)userShouldRateApp
{
    NSString *appStoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", [DZAppRater identifier]];
    
    NSString *webStoreUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", [DZAppRater identifier]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appStoreUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }
    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webStoreUrl]];
    
    [self userDidRateApp];
}


#pragma mark UIAlertViewDelegate Methods

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:RaterAlertButtonOk]) {
        [self userShouldRateApp];
    }
    else if ([buttonTitle isEqualToString:RaterAlertButtonNo]) {
        [self userDidRateApp];
    }
}

@end
