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

@class ORObjectIdentifier;

/**
 * Model object representing a sensor in the OR UI model domain.
 * The only information available at this stage is the sensor identifier.
 *
 * Sensor states are specific to the use of a sensor by a UI widget
 * and are taken care of by the ORSensorStatesMapping and ORSensorLink classes.
 */
@interface ORSensor : NSObject <NSCoding>

/**
 * Initializes the sensor with the given identifier.
 *
 * @param anIdentifier ORObjectIdenfitier to use as identifier for this sensor
 *
 * @return An ORSensor object initialized with the provided identifier.
 */
- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier;

@property (nonatomic, strong, readonly) ORObjectIdentifier *identifier;

@end