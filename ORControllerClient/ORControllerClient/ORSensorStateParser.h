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

#import "DefinitionElementParser.h"

@class ORSensorState;

/**
 * Parses a <state...> XML fragment from the panel XML document
 * into an ORSensorState model object instance.
 *
 * XML fragment example:
 * ......
 * <state name="off" value="light is off" />
 * <state name="on" value="light is on" />
 * ......
 */
@interface ORSensorStateParser : DefinitionElementParser

@property (nonatomic, strong, readonly) ORSensorState *sensorState;

@end
