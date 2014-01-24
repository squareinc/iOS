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

@class ORSensorStatesMapping;

/**
 * Represents a link between a Sensor and a property it updates.
 * This includes the Component and the name of the property.
 *
 * It includes an optional sensor states mapping to should be used
 * to translate the sensor value before assignment to the Component property.
 */
@interface ORSensorLink : NSObject

/**
 * Initializes the SensorLink with the provided information.
 * No check is done on that information (e.g. that the property exists on the component).
 *
 * @param aComponent component the sensor is linked to
 * @param aPropertyName name of the property on the component the sensor updates
 * @param mapping sensor states mapping used to translate sensor value before assignment
 *
 * @return An ORSensorLink object initialized with the provided values.
 */
- (id)initWithComponent:(NSObject *)aComponent
           propertyName:(NSString *)aPropertyName
    sensorStatesMapping:(ORSensorStatesMapping *)mapping;

/**
 * Component sensor is linked to.
 */
@property (nonatomic, strong, readonly) NSObject *component;

/**
 * Name of property that gets updated with sensor value.
 */
@property (nonatomic, strong, readonly) NSString *propertyName;

/**
 * Sensor states mapping used to translate sensor value before assignment.
 */
@property (nonatomic, strong, readonly) ORSensorStatesMapping *sensorStatesMapping;

@end
