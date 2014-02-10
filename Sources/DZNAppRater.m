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

#define DZNAppRaterMessage         [NSString stringWithFormat:@"Would you like to rate %@ on the AppStore?", [self appName]]
#define DZNAppRaterButtonOk        [NSString stringWithFormat:@"Rate %@", [self appName]]
#define DZNAppRaterButtonLater     @"Remind me later"
#define DZNAppRaterButtonNo        @"No, Thanks"

static NSString * const DZNAppRaterIdentifier = @"DZNAppRaterIdentifier";
static NSString * const DZNAppRaterInterval = @"DZNAppRaterInterval";
static NSString * const DZNAppRaterDidRate = @"DZNAppRaterDidRate";
static NSString * const DZNAppRaterSession = @"DZNAppRaterSession";

static BOOL _logEnabled;

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

+ (void)setLogEnabled:(BOOL)enabled
{
    _logEnabled = enabled;
}

+ (void)setAppIdentifier:(NSUInteger)identifier
{
    [self setUserDefaultsValue:[NSNumber numberWithInteger:identifier] forKey:DZNAppRaterIdentifier];
}

+ (void)setTrackingInterval:(NSUInteger)interval
{
    [self setUserDefaultsValue:[NSNumber numberWithInteger:interval] forKey:DZNAppRaterInterval];
}

+ (void)resetTracking
{
    [self setUserDefaultsValue:[NSNumber numberWithInteger:0] forKey:DZNAppRaterSession];
    [self setUserDefaultsValue:[NSNumber numberWithBool:NO] forKey:DZNAppRaterDidRate];
}

+ (void)stopTracking
{
    [self setUserDefaultsValue:[NSNumber numberWithBool:YES] forKey:DZNAppRaterDidRate];
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
    
    if (_logEnabled) {
        NSLog(@"did Rate App already ? %@", didRateApp ? @"Yes" : @"No");
    }
    
    if (!didRateApp) {
        int session = [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterSession] integerValue];
        session++;
        
        if (_logEnabled) {
            NSLog(@"Session # %d",session);
        }
        
        if (session % [self interval] == 0) {
            if (_logEnabled) {
                NSLog(@"Should request for rate");
            }
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:DZNAppRaterButtonOk
                                                                message:DZNAppRaterMessage
                                                               delegate:self
                                                      cancelButtonTitle:DZNAppRaterButtonNo
                                                      otherButtonTitles:DZNAppRaterButtonOk, DZNAppRaterButtonLater, nil];
            [alertview show];
        }

        [self setUserDefaultsValue:[NSNumber numberWithInteger:session] forKey:DZNAppRaterSession];
    }
}

+ (void)openStore
{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", [self identifier]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        [self stopTracking];
    }
}


#pragma mark UIAlertViewDelegate Methods

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:DZNAppRaterButtonOk]) {
        [self openStore];
        
        if (_logEnabled) {
            NSLog(@"Sending user to App Store");
        }
    }
    else if ([buttonTitle isEqualToString:DZNAppRaterButtonNo]) {
        [self stopTracking];
        
        if (_logEnabled) {
            NSLog(@"User rejected rating");
        }
        
    }
}

@end
