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

@class ORSensorState;

/**
 * An ORSensorStatesMapping is a repository for the different values a sensor
 * can have and their translations for its final value.
 */
@interface ORSensorStatesMapping : NSObject

/**
 * Adds given sensor state to this mapping.
 * If a sensor state with that name already exists, it is replaced by the newly provided one.
 *
 * @param state ORSensorState to add to this mapping
 */
- (void)addSensorState:(ORSensorState *)state;

/**
 * Returns the value of the ORSensorState with the given name.
 * This in effect translates the original sensor value to its final one.
 *
 * @param name of the ORSensorState to get the value of
 *
 * @return the translated sensor value for the given name or nil if no state with that name exists
 */
- (NSString *)stateValueForName:(NSString *)stateName;

@end
