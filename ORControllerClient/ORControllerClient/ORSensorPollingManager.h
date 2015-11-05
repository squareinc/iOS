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
@class ORSensorRegistry;
@class ORControllerRESTAPI;

/**
 * Manages the sensor polling loop with an OpenRemote controller.
 * Updates the object model attributes based on the information received.
 *
 * Sensors polled are the one registered in the sensor registries.
 *
 * WARNING: This implementation is not thread-safe and should be accessed from only one thread at a time.
 */
@interface ORSensorPollingManager : NSObject

/**
 * Initializes the manager to poll from controller at given address and use provided registry to update object model.
 *
 * @param api controller api to use to talk to controller
 * @param controllerAddress address of the controller to connect to
 *
 * @return An ORSensorPollingManager object initialized with the provided address.
 */
- (instancetype)initWithControllerAPI:(ORControllerRESTAPI *)api
                    controllerAddress:(ORControllerAddress *)controllerAddress;

/**
 * Adds a sensor registry so that its registered sensor are polled for updates.
 * The poll mechanism is restarted to ensure that the registry's sensor initial value is fetched.
 *
 * @param sensorRegistry registry defining what information in the object model needs updating (and how to update)
 */
- (void)addSensorRegistry:(ORSensorRegistry *)sensorRegistry;

/**
 * Removes a sensor registry so its sensor values are not updated anymore.
 *
 * @param sensorRegistry registry to remove from list of known registry
 */
- (void)removeSensorRegistry:(ORSensorRegistry *)sensorRegistry;

/*
 * Requests current value of sensors registered in registry, then polling mechanism to receive updates to those value.
 * Updates object model accordingly.
 */
- (void)start;

/*
 * Stops the polling loop. No further udpate to object model will happen after this call.
 */
- (void)stop;

@end
