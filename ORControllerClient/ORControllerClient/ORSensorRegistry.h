/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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

@class ORSensor;
@class ORObjectIdentifier;

/**
 * Class is responsible to manage the list of known sensors
 * and appropriately react to sensor values update.
 *
 * This class does not perform any specific logic on update,
 * subclasses will implement appropriate logic.
 */
@interface ORSensorRegistry : NSObject <NSCoding>

/**
 * Fully clears the registry of all information it contains.
 */
- (void)clearRegistry;

/**
 * Adds a sensor to the registry.
 *
 * @param sensor Sensor to add
 */
- (void)registerSensor:(ORSensor *)sensor;

/**
 * Returns the sensor with the given identifier.
 * This works only for sensors that have been registered with this registry.
 *
 * @param sensorIdentifier identifier of sensor to lookup
 *
 * @return Sensor sensor with given it or nil if no such sensor is registered
 */
- (ORSensor *)sensorWithIdentifier:(ORObjectIdentifier *)sensorIdentifier;

/**
 * Returns identifiers of all registered sensors (ORObjectIdentifier instances).
 *
 * @return NSSet set with ORObjectIdentifiers of all registered sensors
 */
- (NSSet *)sensorIdentifiers;


/**
 * Perform appropriate logic based on provided updated sensor values.
 * Implementation in this class does not perform any operation.
 *
 * @param sensorValues NSDictionary with key being an NSString containing sensorId
  *       and value being the last raw (NSString) sensor value read.
 */
- (void)updateWithSensorValues:(NSDictionary *)sensorValues;

@end
