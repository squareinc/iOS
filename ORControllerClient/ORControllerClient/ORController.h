/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

@class ORControllerAddress;
@class ORSimpleUIConfiguration;

/**
 * Represents an OpenRemote ORB
 */
@interface ORController : NSObject

/**
 * Initializes the controller with the provided address.
 * Does not try to connect to the controller.
 * 
 * @param anAddress address of the controller to connect to
 *
 * @return An ORController object initialized with the provided address. If no address is given, returns nil.
 */
- (id)initWithControllerAddress:(ORControllerAddress *)anAddress;



// TODO: need to have a connection manager injected ? It could then have a cache manager injected to it



/**
 * Tries to establish connection to the controller.
 * Reports success/error through provided handlers.
 * successHandler is garanteed to be called after the connection has been established.
 *
 * @param successHandler
 * @param errorHandler
 */
- (void)connectWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;

// TODO: what about authentication, specific handler for providing that when required ?
// TODO: what about connection gets closed just after it is opened ?

/**
 */
- (void)disconnect;

/**
 *
 * @return
 */
- (BOOL)isConnected;

- (void)readSimpleUIConfigurationWithSuccessHandler:(void (^)(ORSimpleUIConfiguration *))successHandler errorHandler:(void (^)(NSError *))errorHandler;




// Below are more advanced features, required for iOS Console

- (void)requestPanelIdentityListWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;

/**
 * First connects to the controller if it's not yet the case.
 *
 * @param successHandler
 * @param errorHandler
 */
- (void)requestPanelUILayout:(NSString *)panelName successHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;



// How about having an FixedUIController that provides higher granularity methods to perform actions required by the project.
// This class can provide finer grained methods to make it compatible with current iOS console.
// e.g. getAllLabels would iterate currently loaded panel for all labels
// readControllerConfiguration would load the list of panels, then read the first panel in the list

// Or have a category for us to provide access to those methods


// TODO: if there is caching, should be able to indicate if configuration is up to date or not, ...
// Maybe need a specific object to manage configuration -> will getLabels be on that object or is this hidden ???


/**
 * Returns all the labels known to this controller.
 * If no configuration has been read for this controller, raises an exception.
 
 // TODO: how is caching implemented, how will this impact this method
 
 *
 * Given the current REST API with controller, it only returns the labels from the 1st panel
 * (but from all screens in all groups).
 */
//- (NSSet *)allLabels;

@end
