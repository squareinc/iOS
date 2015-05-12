/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>

@class ORControllerInfo;
@class ORControllerBrowser;

/**
 * The ORControllerBrowserDelegate protocol defines the optional methods that the ORControllerBrowser
 * delegate object to receive notifiations about discovered controllers or issues during the discovery process.
 */
@protocol ORControllerBrowserDelegate

@optional

/**
 * Reports that a new controller has been found.
 * Note that if the controller does not provide a name or identifier for the controller,
 * those will be set to the same value as the controller address (URL).
 *
 * @param browser ORControllerBrowser sending this delegate message
 *
 * @param controllerInfo ORControllerInfo representing a controller not yet known to the browser
 */
- (void)controllerBrowser:(ORControllerBrowser *)browser didFindController:(ORControllerInfo *)controllerInfo;

/**
 * Reports that a controller already found by the ORControllerBrowser has been updated,
 * that is data was received for an already known controller identifier but with a difference in the other data.
 * The delegate will have previously received a controllerBrowser:didFindController: call for the same idenfier.
 *
 * @param browser ORControllerBrowser sending this delegate message
 *
 * @param controllerInfo ORControllerInfo that was updated
 */
- (void)controllerBrowser:(ORControllerBrowser *)browser didUpdateController:(ORControllerInfo *)controllerInfo;

/**
 * Reports that an error has occured during the auto-discovery process.
 * This most likely indicates an error in sending or receiving information over the network.
 *
 * This error might or might not cause the discoveery process to stop.
 * This can be queried using the isSearching read-only property on the ORControllerBrowser.
 *
 * @param browser ORControllerBrowser sending this delegate message
 *
 * @param error NSError that caused the failure
 */
- (void)controllerBrowser:(ORControllerBrowser *)browser didFail:(NSError *)error;

@end

/**
 * The ORControllerBrowser class defines a means to discover OpenRemote controllers
 * through the auto-discovery mechanism.
 *
 * After the class is initialized, You start and stop searching with the appropriate methods.
 * The class reports found controllers, via its delegate methods, as ORControllerInfo instances.
 * It also maintains a cache of found controllers for its lifetime, that can be queried via the discoveredControllers property.
 *
 * Once search is started, it will continue searching (sending the UDP broadcast) until stopped.
 * The delay between successive broadcast will decrease as time goes by.
 */
@interface ORControllerBrowser : NSObject

/**
 * Starts the discovery process.
 * The browser will start sending UDP broadcast to discover controllers.
 * The frequency of this broadcast decreases expentionally over time.
 *
 * Calling this method, even if a search is already in progress, resets the sending frequency to its initial value.
 *
 * Calling this method does not clear the list of already discovered controllers.
 * If you want to start from scratch, instantiate a new ORControllerBrowser object.
 */
- (void)startSearchingForORControllers;

/**
 * Stops the discovery process.
 * The browser stops sending UDP broadcast to discover controllers and discards any information it receives from controllers.
 */
- (void)stopSearchingForORControllers;

/**
 * The delegate object for this instance, that will receive find, update and error notifications.
 */
@property (nonatomic, weak) NSObject <ORControllerBrowserDelegate> *delegate;

/**
 * A list of the controllers (ORControllerInfo) that have been discovered during the lifetime of this browser.
 */
@property (nonatomic, strong, readonly) NSArray *discoveredControllers;

/**
 * A flag indicating if the search (discovery process) is currently running.
 */
@property (nonatomic, readonly, getter = isSearching) BOOL searching;

@end
