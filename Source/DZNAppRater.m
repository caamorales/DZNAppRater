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

static NSString * const DZNAppRaterIdentifier =     @"DZNAppRaterIdentifier";
static NSString * const DZNAppRaterInterval =       @"DZNAppRaterInterval";
static NSString * const DZNAppRaterDidRate =        @"DZNAppRaterDidRate";
static NSString * const DZNAppRaterSession =        @"DZNAppRaterSession";
static NSString * const DZNAppRaterSelectedStyle =  @"DZNAppRaterSelectedStyle";

static NSString * const DZNAppRaterReviewURL =      @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
static NSString * const DZNAppRaterReviewURLiOS7 =  @"itms-apps://itunes.apple.com/app/id%@";

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

+ (NSUInteger)sessions
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterSession] integerValue];
}

+ (BOOL)didRateApp
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterDidRate] boolValue];
}

+ (NSString *)storeUrl
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [DZNAppRaterReviewURLiOS7 stringByReplacingOccurrencesOfString:@"%@" withString:[@([self identifier]) stringValue]];
    }
    else {
        return [DZNAppRaterReviewURL stringByReplacingOccurrencesOfString:@"%@" withString:[@([self identifier]) stringValue]];
    }
}


#pragma mark - Setter Methods

+ (void)setLogEnabled:(BOOL)enabled
{
    _logEnabled = enabled;
}

+ (void)setAppIdentifier:(NSUInteger)identifier
{
    if (![self didRateApp] && ![self identifier]) {
        [self setUserDefaultsValue:[NSNumber numberWithInteger:identifier] forKey:DZNAppRaterIdentifier];
    }
}

+ (void)setTrackingInterval:(NSUInteger)interval
{
    if (![self didRateApp] && ![self interval]) {
        [self setUserDefaultsValue:[NSNumber numberWithInteger:interval] forKey:DZNAppRaterInterval];
    }
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
    NSAssert([self identifier], @"The App identifier cannot be nil.");
    NSAssert([self interval], @"The tracking interval must be bigger than 0.");

    BOOL didRateApp = [self didRateApp];
    if (_logEnabled) NSLog(@"did Rate App already ? %@", didRateApp ? @"Yes" : @"No");
    
    if (didRateApp) {
        return;
    }
    
    NSUInteger sessions = [self sessions];
    sessions++;
    
    if (_logEnabled) NSLog(@"Session # %d",sessions);
    
    if (sessions % [self interval] == 0) {
        if (_logEnabled)  NSLog(@"Should request for rate");
        [self requestRating];
    }
    
    [self setUserDefaultsValue:[NSNumber numberWithInteger:sessions] forKey:DZNAppRaterSession];
}

+ (void)requestRating
{
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Rate %@", nil), [self appName]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"Would you like to rate %@ on the AppStore?", nil), [self appName]]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No, Thanks", nil)
                                          otherButtonTitles:title, NSLocalizedString(@"Remind me later", nil), nil];
    
    [alert show];
}

+ (void)openStore
{
    NSURL *URL = [NSURL URLWithString:[self storeUrl]];
    [[UIApplication sharedApplication] openURL:URL];
    
    [self stopTracking];
}


#pragma mark UIAlertViewDelegate Methods

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0:
            if (_logEnabled) NSLog(@"User rejected rating");
            [self stopTracking];
            break;
            
        case 1:
            if (_logEnabled) NSLog(@"Sending user to App Store");
            [self openStore];
            break;
    }
}

@end
