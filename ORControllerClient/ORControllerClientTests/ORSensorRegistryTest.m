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
#import "ORSensorLink.h"
#import "Sensor.h"
#import "ORLabel.h"

#define SENSOR_ID_12 [NSNumber numberWithInt:12]
#define SENSOR_ID_13 [NSNumber numberWithInt:13]

@implementation ORSensorRegistryTest

- (void)testRegistryCreation
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    STAssertNotNil([registry sensorIds], @"Newly created registry should still return a collection of sensor ids");
    STAssertEquals((NSUInteger)0, [[registry sensorIds] count], @"No sensors should exist in a newly created registry");
    STAssertNotNil([registry sensorLinksForSensorId:SENSOR_ID_12], @"Newly created should still return a collection of links for a non registered sensor");
    STAssertEquals((NSUInteger)0, [[registry sensorLinksForSensorId:[NSNumber numberWithInt:12]] count], @"No components should be linked to a non existent sensor");
    STAssertNil([registry sensorWithId:SENSOR_ID_12], @"Newly created return nil for a non registered sensor id");
}

- (void)testRegister
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    Sensor *sensor = [[Sensor alloc] initWithId:[SENSOR_ID_12 intValue]];
    ORLabel *label = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:label property:@"text"];
    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after one sensor has been registered");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)1, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be one link for in the registry linked to the sensor");
    ORSensorLink *link = [[registry sensorLinksForSensorId:SENSOR_ID_12] anyObject];
    STAssertEqualObjects(label, link.component, @"Component in the registry associated with sensor id should be the component the sensor is linked to");
    STAssertEquals(@"text", link.propertyName, @"Property in the registry associated with sensor id should be the property the sensor is linked to");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");
    
    STAssertEquals((NSUInteger)0, [[registry sensorLinksForSensorId:SENSOR_ID_13] count], @"No components should be linked to a non existent sensor");
    STAssertNil([registry sensorWithId:SENSOR_ID_13], @"Registry should return nil for a non registered sensor id");
}

- (void)testMultipleRegister
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    Sensor *sensor = [[Sensor alloc] initWithId:[SENSOR_ID_12 intValue]];
    ORLabel *label = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:label property:@"text"];
    [registry registerSensor:sensor linkedToComponent:label property:@"text"];

    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)1, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be one link for in the registry after registering same sensor multiple times");
    ORSensorLink *link = [[registry sensorLinksForSensorId:SENSOR_ID_12] anyObject];
    STAssertEqualObjects(label, link.component, @"Component in the registry associated with sensor id should be the component the sensor is linked to");
    STAssertEquals(@"text", link.propertyName, @"Property in the registry associated with sensor id should be the property the sensor is linked to");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:label property:@"other"];
    
    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)2, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 2 links for in the registry after registering sensor for other property");
    link = [[registry sensorLinksForSensorId:SENSOR_ID_12] anyObject];
    STAssertEqualObjects(label, link.component, @"Component in the registry associated with sensor id should be the component the sensor is linked to");
    STAssertEqualObjects(([NSSet setWithObjects:@"text", @"other", nil]),
                   [[registry sensorLinksForSensorId:SENSOR_ID_12] valueForKey:@"propertyName"],
                   @"Properties in the registry associated with sensor id should be the properties the sensor is linked to");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:label property:@"other"];

    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)2, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 2 links for in the registry after registering sensor for other property");
    link = [[registry sensorLinksForSensorId:SENSOR_ID_12] anyObject];
    STAssertEqualObjects(label, link.component, @"Component in the registry associated with sensor id should be the component the sensor is linked to");
    STAssertEqualObjects(([NSSet setWithObjects:@"text", @"other", nil]),
                         [[registry sensorLinksForSensorId:SENSOR_ID_12] valueForKey:@"propertyName"],
                         @"Properties in the registry associated with sensor id should be the properties the sensor is linked to");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    ORLabel *otherLabel = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"text"];

    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)3, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 3 links for in the registry after registering sensor for other property and other component");
    STAssertEqualObjects(([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"], nil]),
                         [registry sensorLinksForSensorId:SENSOR_ID_12],
                         @"Links in the registry associated with sensor id should be the ones for the registered sensor");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"text"];

    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)3, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 3 links for in the registry after registering sensor for other property and other component");
    STAssertEqualObjects(([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"], nil]),
                         [registry sensorLinksForSensorId:SENSOR_ID_12],
                         @"Links in the registry associated with sensor id should be the ones for the registered sensor");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"other"];

    STAssertEquals((NSUInteger)1, [[registry sensorIds] count], @"There should be one sensor in registry after registering same sensor multiple times");
    STAssertEqualObjects([NSSet setWithObject:SENSOR_ID_12], [registry sensorIds], @"The sensor id in the registry should be the one of the registered sensor");
    STAssertEquals((NSUInteger)4, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 4 links for in the registry after registering sensor for other property and other component");
    STAssertEqualObjects(([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other"], nil]),
                         [registry sensorLinksForSensorId:SENSOR_ID_12],
                         @"Links in the registry associated with sensor id should be the ones for the registered sensor");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"other"];
    
    Sensor *otherSensor = [[Sensor alloc] initWithId:[SENSOR_ID_13 intValue]];
    [registry registerSensor:otherSensor linkedToComponent:label property:@"text"];

    STAssertEquals((NSUInteger)2, [[registry sensorIds] count], @"There should be 2 sensors in registry after registering second sensor");
    STAssertEqualObjects(([NSSet setWithObjects:SENSOR_ID_12, SENSOR_ID_13, nil]),
                         [registry sensorIds],
                         @"The sensor ids in the registry should be the one of the registered sensors");
    STAssertEquals((NSUInteger)4, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 4 links for the first sensor in the registry  after registering second sensor");
    STAssertEqualObjects(([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other"], nil]),
                         [registry sensorLinksForSensorId:SENSOR_ID_12],
                         @"Links in the registry associated with sensor id should be the ones for the first registered sensor");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a first registered sensor");

    STAssertEquals((NSUInteger)1, [[registry sensorLinksForSensorId:SENSOR_ID_13] count], @"There should be 1 link for the second sensor in the registry  after registering second sensor");
    STAssertEqualObjects([NSSet setWithObject:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"]],
                          [registry sensorLinksForSensorId:SENSOR_ID_13],
                         @"Link in the registry associated with sensor id should be the one for the second registered sensor");
    STAssertEquals(otherSensor, [registry sensorWithId:SENSOR_ID_13], @"Registry should return sensor for id of a second registered sensor");

    [registry registerSensor:otherSensor linkedToComponent:label property:@"text"];

    STAssertEquals((NSUInteger)2, [[registry sensorIds] count], @"There should be 2 sensors in registry after registering second sensor");
    STAssertEqualObjects(([NSSet setWithObjects:SENSOR_ID_12, SENSOR_ID_13, nil]),
                         [registry sensorIds],
                         @"The sensor ids in the registry should be the one of the registered sensors");
    STAssertEquals((NSUInteger)4, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"There should be 4 links for the first sensor in the registry  after registering second sensor");
    STAssertEqualObjects(([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other"], nil]),
                         [registry sensorLinksForSensorId:SENSOR_ID_12],
                         @"Links in the registry associated with sensor id should be the ones for the first registered sensor");
    STAssertEquals(sensor, [registry sensorWithId:SENSOR_ID_12], @"Registry should return sensor for id of a first registered sensor");
    
    STAssertEquals((NSUInteger)1, [[registry sensorLinksForSensorId:SENSOR_ID_13] count], @"There should be 1 link for the second sensor in the registry  after registering second sensor");
    STAssertEqualObjects([NSSet setWithObject:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text"]],
                         [registry sensorLinksForSensorId:SENSOR_ID_13],
                         @"Link in the registry associated with sensor id should be the one for the second registered sensor");
    STAssertEquals(otherSensor, [registry sensorWithId:SENSOR_ID_13], @"Registry should return sensor for id of a second registered sensor");
}

- (void)testClearRegistry
{
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    Sensor *sensor = [[Sensor alloc] initWithId:[SENSOR_ID_12 intValue]];
    ORLabel *label = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:label property:@"text"];
    [registry clearRegistry];
    STAssertNotNil([registry sensorIds], @"Cleared registry should still return a collection of sensor ids");
    STAssertEquals((NSUInteger)0, [[registry sensorIds] count], @"No sensors should exist after registry has been cleared");
    STAssertNotNil([registry sensorLinksForSensorId:SENSOR_ID_12], @"Cleared registry should still return a collection of links for a non registered sensor");
    STAssertEquals((NSUInteger)0, [[registry sensorLinksForSensorId:SENSOR_ID_12] count], @"No components should be linked to a non existent sensor");
    STAssertNil([registry sensorWithId:SENSOR_ID_12], @"Registry should return nil for a non registered sensor id");
}

@end