//
//  ORSensorRegistry.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 01/08/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

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
