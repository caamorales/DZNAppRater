//
//  DZAppRater.h
//  SimpleRater
//
//  Created by Ignacio on 10/23/12.
//  Copyright (c) 2012 DZEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZAppRater : NSObject <UIAlertViewDelegate>

/**
 * Returns a singletone object.
 *
 * @returns The shared instance object.
*/
+ (DZAppRater *)sharedInstance;

/**
 * Sets the Appplication's unique Identifier from the AppStore.
 * This implementation must be called before the startRaterTracking method.
 *
 * @param identifier Your application identifier.
*/
- (void)setAppIdentifier:(NSUInteger)identifier;

/**
 * Sets the rater interval value.
 * This interval must match up with the sessions incremental counting, to trigger the alert view. 
 * This implementation should be called before the startRaterTracking method.
 *
 * @param identifier Your rater interval.
 */
- (void)setRaterInterval:(NSUInteger)interval;

/**
 * Starts the session counting to reach the limit interval.
 * When reached the limit, and the user hasn't yet rate the app, it triggers the alert view.
 * You should call this method on your AppDelegate's application:didFinishLaunchingWithOptions:
*/
- (void)startTracking;

/**
 * Removes all data saved into the NSUserDefaults.
 * Use this methos to reset the component to zero.
*/
- (void)resetTracking;

@end
