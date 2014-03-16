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
 * Sets the Application's unique identifier on iTunes.
 * This implementation must be called before the +startTracking method.
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
 * Enables the log messages.
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
 * Stops the session counting and disables tracking for good.
 */
+ (void)stopTracking;

/**
 * Removes all data saved into the NSUserDefaults.
 * Use this method to reset the component to zero.
*/
+ (void)resetTracking;

/**
 * Prompts the alert view for requesting the user for rate the app.
 * The user's actions will cause the exact same result as it would be when called automatically after interval.
 */
+ (void)requestRating;

/**
 * Returns the appropriate App Store url for the app identifier.
 * @return The App Store url.
 */
+ (NSString *)storeUrl;

/**
 * Opens the App Store view with the application identifier for reviewing.
 * Calling this, disables the tracker for good since you may expect that the user rated your app.
 */
+ (void)openStore;


@end
