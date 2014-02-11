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

#define DZNAppRaterMessage                          [NSString stringWithFormat:@"Would you like to rate %@ on the AppStore?", [self appName]]
#define DZNAppRaterButtonOk                         [NSString stringWithFormat:@"Rate %@", [self appName]]
#define DZNAppRaterButtonLater                      @"Remind me later"
#define DZNAppRaterButtonNo                         @"No, Thanks"

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

+ (BOOL)didRateApp
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterDidRate] boolValue];
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
    
    int session = [[[NSUserDefaults standardUserDefaults] objectForKey:DZNAppRaterSession] integerValue];
    session++;
    
    if (_logEnabled) NSLog(@"Session # %d",session);
    
    if (session % [self interval] == 0) {
        if (_logEnabled)  NSLog(@"Should request for rate");
        [self requestRating];
    }
    
    [self setUserDefaultsValue:[NSNumber numberWithInteger:session] forKey:DZNAppRaterSession];
}

+ (void)requestRating
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DZNAppRaterButtonOk
                                                    message:DZNAppRaterMessage
                                                   delegate:self
                                          cancelButtonTitle:DZNAppRaterButtonNo
                                          otherButtonTitles:DZNAppRaterButtonOk, DZNAppRaterButtonLater, nil];
    
    [alert show];
}

+ (void)openStore
{
    NSString *url = nil;
    NSString *string = [NSString stringWithFormat:@"%d", [self identifier]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        url = [DZNAppRaterReviewURLiOS7 stringByReplacingOccurrencesOfString:@"%@" withString:string];
    }
    else {
        url = [DZNAppRaterReviewURL stringByReplacingOccurrencesOfString:@"%@" withString:string];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        [self stopTracking];
    }
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
