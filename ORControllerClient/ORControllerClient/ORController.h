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

#import <UIKit/UIKit.h>
#import "ORAuthenticationManager.h"

@class ORControllerAddress;

@class Definition;
@class ORButton;
@class ORSwitch;
@class ORSlider;
@class ORColorPicker;
@class ORGesture;

/**
 * Represents an OpenRemote ORB
 */
@interface ORController : NSObject

/**
 * Initializes the controller with the provided address.
 * Does not try to connect to the controller.
 * 
 * @param anAddress The address of the controller to connect to.
 *
 * @return An ORController object initialized with the provided address. If no address is given, returns nil.
 */
- (instancetype)initWithControllerAddress:(ORControllerAddress *)anAddress;



// TODO: need to have a connection manager injected ? It could then have a cache manager injected to it



/**
 * Establishes connection to the controller.
 * If the controller already has a definition attached to it, this also restarts polling for model updates.
 * 
 * Reports success/error through provided handlers.
 * successHandler is guaranteed to be called after the connection has been established.
 * Both handlers are guaranteed to be called on the same thread that initially called this method.
 *
 * @param successHandler A block object to be executed once connection to the controller has been established.
 * This block has no return value and does not take any parameter.
 * @param errorHandler A block object to be executed if connection to the controller fails.
 * This block has no return value and takes a single NSError * argument indicating the error that occurred. This parameter may be NULL.
 */
- (void)connectWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;

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
 * Both handlers are guaranteed to be called on the same thread that initially called this method.
 *
 * @param successHandler A block object to be executed once the controller configuration has been successfully read.
 * This block has no return value and takes a single NSArray * argument with all the panel identities.
 * The elements of the array are ORPanel instances.
 * @param errorHandler A block object to be executed if the controller configuration cannot be retrieved.
 * This block has no return value and takes a single NSError * argument indicating the error that occurred. This parameter may be NULL.
 */
- (void)requestPanelIdentityListWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

/**
 * Requests the full panel layout definition of a given panel.
 * TODO: First connects to the controller if it's not yet the case. ??? really ?
 * Both handlers are guaranteed to be called on the same thread that initially called this method.
 *
 * After this call, the properties of the returned data model will be updated based on controller feedback,
 * for as long as connection to the controller stays open.
 *
 * @param panelName Logical name of panel to get layout definition of
 * @param successHandler A block object to be executed once the panel layout definition has been successfully read from the controller.
 * This block has no return value and takes a single Definition * argument that provides panel layout information.
 * @param errorHandler A block object to be executed if the definition cannot be retrieved from controller.
 * This block has no return value and takes a single NSError * argument indicating the error that occurred. This parameter may be NULL.
 */
- (void)requestPanelUILayout:(NSString *)panelName successHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

// TODO: if there is caching, should be able to indicate if configuration is up to date or not, ...
// Maybe need a specific object to manage configuration -> will getLabels be on that object or is this hidden ???
// TODO: how is caching implemented, how will this impact this method


/**
 * Attaches the panel layout definition to this controller.
 * If there is currently a connecting to the controller, this method restarts polling for object model changes.
 *
 * Dettaches it from previous controller if it was already attached.
 *
 * @param panelDefinition The panel layout definition to attach to this controller.
 */
- (void)attachPanelDefinition:(Definition *)panelDefinition;

/**
 * Retrieves a resource with the given name from the controller.
 * Both handlers are guaranteed to be called on the same thread that initially called this method.
 *
 * @param resourceName The name of the resource to retrieve.
 * @param successHandler A block object to be executed once the resource has been successfully retrieved from the controller.
 * This block has no return value and takes a single NSData * argument that provides the unprocessed binary content of the resource.
 * @param errorHandler A block object to be executed if the definition cannot be retrieved from controller.
 * This block has no return value and takes a single NSError * argument indicating the error that occurred. This parameter may be NULL.
 */
- (void)retrieveResourceNamed:(NSString *)resourceName successHandler:(void (^)(NSData *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

- (void)sendPressCommandForButton:(ORButton *)sender;
- (void)sendShortReleaseCommandForButton:(ORButton *)sender;
- (void)sendLongPressCommandForButton:(ORButton *)sender;
- (void)sendLongReleaseCommandForButton:(ORButton *)sender;

- (void)sendOnForSwitch:(ORSwitch *)sender;
- (void)sendOffForSwitch:(ORSwitch *)sender;

- (void)sendValue:(float)value forSlider:(ORSlider *)sender;

- (void)sendColor:(UIColor *)color forPicker:(ORColorPicker *)sender;

- (void)performGesture:(ORGesture *)sender;

/**
 * The authentication manager that can provide credential during calls.
 */
@property (nonatomic, strong) NSObject <ORAuthenticationManager> *authenticationManager;

@end
