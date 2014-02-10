//
//  DZNAppRater.h
//  DZNAppRater
//  https://github.com/dzenbot/DZNAppRater
//
//  Created by Ignacio Romero Zurbuchen on 10/23/12.
//  Copyright (c) 2012 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>

@interface DZNAppRater : NSObject

/**
 * Sets the Appplication's unique Identifier from the AppStore.
 * This implementation must be called before the startRaterTracking method.
 *
 * @param identifier Your application identifier.
*/
+ (void)setAppIdentifier:(NSUInteger)identifier;

/**
 * Sets the tracking interval value.
 * This interval must match up with the sessions incremental counting, to trigger the alert view. 
 * This implementation should be called before the startRaterTracking method.
 *
 * @param identifier Your rater interval.
 */
+ (void)setTrackingInterval:(NSUInteger)interval;

/**
 * Enables the log messges.
 *
 * @param enabled YES if the log message should show. Default NO.
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 * Starts the session counting to reach the limit interval.
 * When reached the limit, and the user hasn't yet rate the app, it triggers the alert view.
 * You should call this method on your AppDelegate's application:didFinishLaunchingWithOptions:
*/
+ (void)startTracking;

/**
 * Removes all data saved into the NSUserDefaults.
 * Use this method to reset the component to zero.
*/
+ (void)resetTracking;

@end
