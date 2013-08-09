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

@class Definition;

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
 * Establishes connection to the controller.
 * Reports success/error through provided handlers.
 * successHandler is garanteed to be called after the connection has been established.
 *
 * @param successHandler A block object to be executed once connection to the controller has been established.
 * This block has no return value and does not take any parameter.
 * @param errorHandler A block object to be executed if connection to the controller fails.
 * This block has no return value and takes a single NSError * argument indicating the error that occured. This parameter may be NULL.
 */
- (void)connectWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;

// TODO: what about authentication, specific handler for providing that when required ?
// TODO: what about connection gets closed just after it is opened ?

/**
 * Closes the connection to the controller.
 * After calling this method, properties of the data model will not be updated anymore (e.g. when linked to a sensor).
 *
 * If the connection was not established, this method does nothing.
 */
- (void)disconnect;

/**
 * Returns a Boolean value indicating whether a connection is currently established to the controller.
 *
 * @return YES if a connection is currently established to the controller; otherwise, NO.
 */
- (BOOL)isConnected;

/**
 * Requests the list of panel identities in the configuration of this controller.
 *
 * @param successHandler A block object to be executed once the controller configuration has been succesfully read.
 * This block has no return value and takes a single NSArray * argument with all the panel identities.
 * The elements of the array are ORPanel instances.
 * @param errorHandler A block object to be executed if the controller configuration cannot be retrieved.
 * This block has no return value and takes a single NSError * argument indicating the error that occured. This parameter may be NULL.
 */
- (void)requestPanelIdentityListWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

/**
 * Requests the full panel layout definition of a given panel.
 * TODO: First connects to the controller if it's not yet the case. ??? really ?
 *
 * After this call, the properties of the returned data model will be updated based on controller feedback,
 * for as long as connection to the controller stays open.
 *
 * @param panelName Logical name of panel to get layout definition of
 * @param successHandler A block object to be executed once the panel layout definition has been succesfully read from the controller.
 * This block has no return value and takes a single Definition * argument that provides panel layout information.
 * @param errorHandler A block object to be executed if the definition cannot be retrieved from controller.
 * This block has no return value and takes a single NSError * argument indicating the error that occured. This parameter may be NULL.
 */
- (void)requestPanelUILayout:(NSString *)panelName successHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

// TODO: if there is caching, should be able to indicate if configuration is up to date or not, ...
// Maybe need a specific object to manage configuration -> will getLabels be on that object or is this hidden ???
// TODO: how is caching implemented, how will this impact this method
 
@end
