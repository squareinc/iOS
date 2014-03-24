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

/**
 * An ORSensorState is a key-value pair that allows translation of one sensor original value
 * (the name) to its final value (the value).
 */
@interface ORSensorState : NSObject

/**
 * Initializes the sensor state with a name and a value.
 * A nil sensorName is not allowed.
 *
 * @param sensorName original value to be translated
 * @param sensorValue final value after translation
 *
 * @return An ORSensorState object initialized with the provided name and value
 * or nil of the sensorName is nil
 */
- (instancetype)initWithName:(NSString *)sensorName value:(NSString *)sensorValue;

/**
 * Original value to be translated.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Final value after translation.
 */
@property (nonatomic, copy, readonly) NSString *value;

@end