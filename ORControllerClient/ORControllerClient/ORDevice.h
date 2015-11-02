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

@class ORObjectIdentifier;
@class ORDeviceCommand;
@class ORDeviceSensor;


@interface ORDevice : NSObject

/**
 * The name of the device.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * The identifier of the device.
 */
@property (nonatomic, strong, readonly) ORObjectIdentifier *identifier;

/**
 * The commands of the device
 */
@property (nonatomic, strong, readonly) NSArray<ORDeviceCommand *> *commands;

/**
 * The sensors of the device
 */
@property (nonatomic, strong, readonly) NSArray<ORDeviceCommand *> *sensors;

/**
 * Find a device command by its id
 *
 * @return a device or nil if no device was found
 */
- (ORDeviceCommand *)findCommandById:(ORObjectIdentifier *)id;

/**
 * Find a device command by its name
 *
 * @return a device or nil if no device was found
 */
- (ORDeviceCommand *)findCommandByName:(NSString *)name;

/**
 * Find device commands by its tag(s)
 *
 * @return a NSSet of devices. The set can be empty
 */
- (NSSet<ORDeviceCommand *> *)findCommandsByTags:(NSSet<NSString *>*)tags;

/**
 * Find a device sensor by its id
 *
 * @return a sensor or nil if no device was found
 */
- (ORDeviceSensor *)findSensorById:(ORObjectIdentifier *)id;

/**
 * Find a device sensor by its name
 *
 * @return a sensor or nil if no device was found
 */
- (ORDeviceSensor *)findSensorByName:(NSString *)name;

@end
