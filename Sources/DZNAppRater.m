//
//  DZNAppRater.m
//  DZNAppRater
//  https://github.com/dzenbot/DZNAppRater
//
//  Created by Ignacio Romero Zurbuchen on 10/23/12.
//  Copyright (c) 2012 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNAppRater.h"

#define DZNAppRaterMessage         [NSString stringWithFormat:@"Would you like to rate %@ on the AppStore?", [DZNAppRater appName]]
#define DZNAppRaterButtonOk        [NSString stringWithFormat:@"Rate %@", [DZNAppRater appName]]
#define DZNAppRaterButtonLater     @"Remind me later"
#define DZNAppRaterButtonNo        @"No, Thanks"

static NSString * const DZNAppRaterIdentifier = @"DZNAppRaterIdentifier";
static NSString * const DZNAppRaterInterval = @"DZNAppRaterInterval";
static NSString * const DZNAppRaterDidRate = @"DZNAppRaterDidRate";
static NSString * const DZNAppRaterSession = @"DZNAppRaterSession";

@interface DZNAppRater ()
@end

@implementation DZNAppRater

#pragma mark - Getter Methods

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSUInteger)identifier
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterIdentifier] integerValue];
}

+ (NSUInteger)interval
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterInterval] integerValue];
}


#pragma mark - Setter Methods

+ (void)setAppIdentifier:(NSUInteger)identifier
{
    [DZNAppRater setUserDefaultsValue:[NSNumber numberWithInteger:identifier] forKey:DZNAppRaterIdentifier];
}

+ (void)setTrackingInterval:(NSUInteger)interval
{
    [DZNAppRater setUserDefaultsValue:[NSNumber numberWithInteger:interval] forKey:DZNAppRaterInterval];
}

+ (void)resetTracking
{
    [DZNAppRater setUserDefaultsValue:[NSNumber numberWithInteger:0] forKey:DZNAppRaterSession];
    [DZNAppRater setUserDefaultsValue:[NSNumber numberWithBool:NO] forKey:DZNAppRaterDidRate];
}

+ (void)userDidRateApp
{
    [DZNAppRater setUserDefaultsValue:[NSNumber numberWithBool:YES] forKey:DZNAppRaterDidRate];
}

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)aKey
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:aKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - DZNAppRater Methods

+ (void)startTracking
{
    BOOL didRateApp = [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterDidRate] boolValue];
    
    NSLog(@"did Rate App already ? %@", didRateApp ? @"Yes" : @"No");
    
    if (!didRateApp)
    {
        int session = [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterSession] integerValue];
        session++;
        
        NSLog(@"Session # %d",session);
        
        if (session % [DZNAppRater interval] == 0)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:DZNAppRaterButtonOk
                                                                message:DZNAppRaterMessage
                                                               delegate:self
                                                      cancelButtonTitle:DZNAppRaterButtonNo
                                                      otherButtonTitles:DZNAppRaterButtonOk, DZNAppRaterButtonLater, nil];
            [alertview show];
        }

        [DZNAppRater setUserDefaultsValue:[NSNumber numberWithInteger:session] forKey:DZNAppRaterSession];
    }
}

+ (void)userShouldRateApp
{
    NSString *appStoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", [DZNAppRater identifier]];
    
    NSString *webStoreUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", [DZNAppRater identifier]];
    
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
    
    if ([buttonTitle isEqualToString:DZNAppRaterButtonOk]) {
        [self userShouldRateApp];
    }
    else if ([buttonTitle isEqualToString:DZNAppRaterButtonNo]) {
        [self userDidRateApp];
    }
}

@end