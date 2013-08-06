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

@class Component;
@class Sensor;

/**
 * Class is responsible to manage the list of known sensors
 * and the UI widgets dependency on those sensors.
 */
@interface ORSensorRegistry : NSObject

/**
 * Fully clear the registry of all information it contains.
 */
- (void)clearRegistry;

/**
 * Adds a sensor to the registry, keeping track of the relationship to the component.
 * If sensor exists not linked to that component, dependency is added.
 * If sensor exists and component is already linked to it, calling this method does not do anything.
 *
 * TODO: for now, component is an NSObject and not a Component because of Label vs ORLabel dichotomoy, should fix in the future.
 *
 */
- (void)registerSensor:(Sensor *)sensor linkedToComponent:(NSObject *)component;

/**
 * Returns the list of all components that are linked to a given sensor.
 */
- (NSSet *)componentsLinkedToSensorId:(NSNumber *)sensorId;

/**
 * Returns ids of all registered sensors (encapsulated as NSNumber).
 */
- (NSSet *)sensorIds;

@end
