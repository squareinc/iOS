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

#import "ORSensorRegistryTest.h"
#import "ORSensorRegistry.h"
#import "Sensor.h"
#import "ORLabel.h"

@implementation ORSensorRegistryTest

- (void)testRegistryCreation
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    STAssertEquals((NSUInteger)0, [[registry sensorIds] count], @"No sensors should exist in a newly created registry");
    STAssertEquals((NSUInteger)0, [[registry componentsLinkedToSensorId:[NSNumber numberWithInt:12]] count], @"No components should be linked to a non existent sensor");
}

- (void)testRegister
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    Sensor *sensor = [[Sensor alloc] initWithId:12];
    ORLabel *label = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:label];
    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after one sensor has been registered");
    STAssertEqualObjects([NSSet setWithObject:[NSNumber numberWithInt:12]], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)1, [[registry componentsLinkedToSensorId:[NSNumber numberWithInt:12]] count], @"There should be one component for in the registery linked to the sensor");
    STAssertEquals((NSUInteger)0, [[registry componentsLinkedToSensorId:[NSNumber numberWithInt:13]] count], @"No components should be linked to a non existent sensor");
    STAssertEqualObjects([NSSet setWithObject:label], [registry componentsLinkedToSensorId:[NSNumber numberWithInt:12]], @"Component in the registry associated with sensor id should be the component the sensor is linked to");
}

- (void)testClearRegistry
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    Sensor *sensor = [[Sensor alloc] initWithId:12];
    ORLabel *label = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:label];
    [registry clearRegistry];
    STAssertEquals((NSUInteger)0, [[registry sensorIds] count], @"No sensors should exist after registry has been cleared");
    STAssertEquals((NSUInteger)0, [[registry componentsLinkedToSensorId:[NSNumber numberWithInt:12]] count], @"No components should be linked to a non existent sensor");
}

@end