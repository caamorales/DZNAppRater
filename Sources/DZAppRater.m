//
//  DZAppRater.m
//  SimpleRater
//
//  Created by Ignacio on 10/23/12.
//  Copyright (c) 2012 DZEN. All rights reserved.
//

#import "DZAppRater.h"

@interface DZAppRater ()

@property (nonatomic, assign) NSUInteger appIdentifier;
@property (nonatomic, assign) NSUInteger raterInterval;

@end

#define DZAppRaterAlertTitle [NSString stringWithFormat:@"Rate %@", [DZAppRater appName]]
#define DZAppRaterAlertMessage [NSString stringWithFormat:@"Would you like to rat %@ on the AppStore?", [DZAppRater appName]]

#define DZAppRaterAlertButtonCancel @"Remind me later"
#define DZAppRaterAlertButtonOK @"Yes, rate it!"
#define DZAppRaterAlertButtonNever @"Don't ask again"

@implementation DZAppRater
@synthesize appIdentifier = _appIdentifier;
@synthesize raterInterval = _raterInterval;

#pragma mark - Getter Methods

+ (DZAppRater *)sharedInstance
{
    static dispatch_once_t pred;
    __strong static DZAppRater *__sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        __sharedInstance = [[DZAppRater alloc] init];
    });
    
	return __sharedInstance;
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}


#pragma mark - Setter Methods

- (void)setAppIdentifier:(NSUInteger)identifier
{
    _appIdentifier = identifier;
}

- (void)setRaterInterval:(NSUInteger)interval
{
    _raterInterval = interval;
}


#pragma mark - DZAppRater Methods

- (void)startTracking
{
    BOOL didRateApp = [[NSUserDefaults standardUserDefaults] boolForKey:@"DZAppRaterDidRate"];
    
    if (!didRateApp)
    {
        int sessions = [[NSUserDefaults standardUserDefaults] integerForKey:@"DZAppRaterSessions"];
        sessions++;
        
        if (sessions % _raterInterval == 0)
        {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:DZAppRaterAlertTitle
                                                                message:DZAppRaterAlertMessage
                                                               delegate:self
                                                      cancelButtonTitle:DZAppRaterAlertButtonCancel
                                                      otherButtonTitles:DZAppRaterAlertButtonOK, DZAppRaterAlertButtonNever, nil];
            [alertview show];
        }
        
        [[NSUserDefaults standardUserDefaults] setInteger:sessions forKey:@"DZAppRaterSessions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)resetTracking
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"DZAppRaterSessions"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DZAppRaterDidRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userDidRateApp
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DZAppRaterDidRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userWillRateApp
{
    NSString *appStoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", _appIdentifier];
    
    NSString *webStoreUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", _appIdentifier];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appStoreUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }
    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webStoreUrl]];
        
    [self userDidRateApp];
}


#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:DZAppRaterAlertButtonOK]) {
        [self userWillRateApp];
    }
    else if ([buttonTitle isEqualToString:DZAppRaterAlertButtonNever]) {
        [self userDidRateApp];
    }
}

@end
