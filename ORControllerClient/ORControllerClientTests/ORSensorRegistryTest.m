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
#import "ORPanelDefinitionSensorRegistry.h"
#import "ORSensorLink.h"
#import "ORSensor.h"
#import "ORSensorStatesMapping.h"
#import "ORSensorState.h"
#import "ORLabel.h"
#import "ORObjectIdentifier.h"

#define SENSOR_ID_12 [[ORObjectIdentifier alloc] initWithIntegerId:12]
#define SENSOR_ID_13 [[ORObjectIdentifier alloc] initWithIntegerId:13]

@implementation ORSensorRegistryTest

- (void)testRegistryCreation
{
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    XCTAssertNotNil([registry sensorIdentifiers], @"Newly created registry should still return a collection of sensor identifiers");
    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)0, @"No sensors should exist in a newly created registry");
    XCTAssertNotNil([registry sensorLinksForSensorIdentifier:SENSOR_ID_12], @"Newly created should still return a collection of links for a non registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)0, @"No components should be linked to a non existent sensor");
    XCTAssertNil([registry sensorWithIdentifier:SENSOR_ID_12], @"Newly created return nil for a non registered sensor identifier");
}

- (void)testRegister
{
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    ORSensor *sensor = [[ORSensor alloc] initWithIdentifier:SENSOR_ID_12];
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:mapping];
    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1, @"There should be one sensor in registry after one sensor has been registered");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)1,
                   @"There should be one link for in the registry linked to the sensor");
    ORSensorLink *link = [[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] anyObject];
    XCTAssertEqualObjects(link.component, label,
                         @"Component in the registry associated with sensor identifier should be the component the sensor is linked to");
    XCTAssertEqualObjects(link.propertyName, @"text",
                         @"Property in the registry associated with sensor identifier should be the property the sensor is linked to");
    XCTAssertEqualObjects(link.sensorStatesMapping, mapping,
                         @"Mapping in the registry associated with sensor identifier should be the mapping used when linking");

    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");
    
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_13] count], (NSUInteger)0,
                   @"No components should be linked to a non existent sensor");
    XCTAssertNil([registry sensorWithIdentifier:SENSOR_ID_13], @"Registry should return nil for a non registered sensor identifier");
}

- (void)testMultipleRegister
{
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    ORSensor *sensor = [[ORSensor alloc] initWithIdentifier:SENSOR_ID_12];
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:mapping];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:mapping];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)1,
                   @"There should be one link for in the registry after registering same sensor multiple times");
    ORSensorLink *link = [[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] anyObject];
    XCTAssertEqualObjects(link.component, label,
                         @"Component in the registry associated with sensor identifier should be the component the sensor is linked to");
    XCTAssertEqualObjects(link.propertyName, @"text",
                         @"Property in the registry associated with sensor identifier should be the property the sensor is linked to");
    XCTAssertEqualObjects(link.sensorStatesMapping, mapping,
                         @"Mapping in the registry associated with sensor identifier should be the mapping used when linking");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:label property:@"other" sensorStatesMapping:nil];
    
    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)2,
                   @"There should be 2 links in the registry after registering sensor for other property");
    link = [[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] anyObject];
    XCTAssertEqualObjects(link.component, label,
                         @"Component in the registry associated with sensor identifier should be the component the sensor is linked to");
    XCTAssertEqualObjects([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] valueForKey:@"propertyName"],
                         ([NSSet setWithObjects:@"text", @"other", nil]),
                   @"Properties in the registry associated with sensor identifier should be the properties the sensor is linked to");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:label property:@"other" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)2,
                   @"There should be 2 links for in the registry after registering sensor for other property");
    link = [[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] anyObject];
    XCTAssertEqualObjects(link.component, label,
                         @"Component in the registry associated with sensor identifier should be the component the sensor is linked to");
    XCTAssertEqualObjects([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] valueForKey:@"propertyName"],
                         ([NSSet setWithObjects:@"text", @"other", nil]),
                         @"Properties in the registry associated with sensor identifier should be the properties the sensor is linked to");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    ORLabel *otherLabel = [[ORLabel alloc] init];
    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"text" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor id in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)3,
                   @"There should be 3 links for in the registry after registering sensor for other property and other component");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_12],
                         ([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:nil], nil]),
                         @"Links in the registry associated with sensor identifier should be the ones for the registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"text" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)3,
                   @"There should be 3 links for in the registry after registering sensor for other property and other component");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_12],
                         ([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:nil], nil]),
                         @"Links in the registry associated with sensor identifier should be the ones for the registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"other" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)4,
                   @"There should be 4 links for in the registry after registering sensor for other property and other component");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_12],
                         ([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other" sensorStatesMapping:nil], nil]),
                         @"Links in the registry associated with sensor identifier should be the ones for the registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");

    [registry registerSensor:sensor linkedToComponent:otherLabel property:@"other" sensorStatesMapping:nil];
    
    ORSensor *otherSensor = [[ORSensor alloc] initWithIdentifier:SENSOR_ID_13];
    [registry registerSensor:otherSensor linkedToComponent:label property:@"text" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)2, @"There should be 2 sensors in registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorIdentifiers],
                         ([NSSet setWithObjects:SENSOR_ID_12, SENSOR_ID_13, nil]),
                         @"The sensor identifiers in the registry should be the one of the registered sensors");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)4,
                   @"There should be 4 links for the first sensor in the registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_12],
                         ([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other" sensorStatesMapping:nil], nil]),
                         @"Links in the registry associated with sensor identifier should be the ones for the first registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a first registered sensor");

    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_13] count], (NSUInteger)1,
                   @"There should be 1 link for the second sensor in the registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_13],
                         [NSSet setWithObject:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:nil]],
                         @"Link in the registry associated with sensor identifier should be the one for the second registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_13], otherSensor, @"Registry should return sensor for identifier of a second registered sensor");

    [registry registerSensor:otherSensor linkedToComponent:label property:@"text" sensorStatesMapping:nil];

    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)2, @"There should be 2 sensors in registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorIdentifiers],
                         ([NSSet setWithObjects:SENSOR_ID_12, SENSOR_ID_13, nil]),
                         @"The sensor ids in the registry should be the one of the registered sensors");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)4,
                   @"There should be 4 links for the first sensor in the registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_12],
                         ([NSSet setWithObjects:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping],
                           [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:nil],
                           [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other" sensorStatesMapping:nil], nil]),
                         @"Links in the registry associated with sensor identifier should be the ones for the first registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a first registered sensor");
    
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_13] count], (NSUInteger)1,
                   @"There should be 1 link for the second sensor in the registry after registering second sensor");
    XCTAssertEqualObjects([registry sensorLinksForSensorIdentifier:SENSOR_ID_13],
                         [NSSet setWithObject:[[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:nil]],
                         @"Link in the registry associated with sensor identifier should be the one for the second registered sensor");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_13], otherSensor, @"Registry should return sensor for identifier of a second registered sensor");
}

- (void)testMultipleRegisterWithDifferentMappingsOverrideMapping
{
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    ORSensor *sensor = [[ORSensor alloc] initWithIdentifier:SENSOR_ID_12];
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:mapping];
    
    ORSensorStatesMapping *otherMapping = [[ORSensorStatesMapping alloc] init];
    [otherMapping addSensorState:[[ORSensorState alloc] initWithName:@"off" value:@"Off value"]];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:otherMapping];
    
    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)1,
                   @"There should be one sensor in registry after registering same sensor multiple times");
    XCTAssertEqualObjects([registry sensorIdentifiers], [NSSet setWithObject:SENSOR_ID_12],
                         @"The sensor identifier in the registry should be the one of the registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)1,
                   @"There should be one link for in the registry after registering same sensor multiple times");
    ORSensorLink *link = [[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] anyObject];
    XCTAssertEqualObjects(link.component, label,
                         @"Component in the registry associated with sensor identifier should be the component the sensor is linked to");
    XCTAssertEqualObjects(link.propertyName, @"text",
                         @"Property in the registry associated with sensor identifier should be the property the sensor is linked to");
    XCTAssertEqualObjects(link.sensorStatesMapping, otherMapping,
                         @"Mapping in the registry associated with sensor identifier should be the mapping used for last register");
    XCTAssertEqual([registry sensorWithIdentifier:SENSOR_ID_12], sensor, @"Registry should return sensor for identifier of a registered sensor");
}

- (void)testClearRegistry
{
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    ORSensor *sensor = [[ORSensor alloc] initWithIdentifier:SENSOR_ID_12];
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:mapping];
    [registry clearRegistry];
    XCTAssertNotNil([registry sensorIdentifiers], @"Cleared registry should still return a collection of sensor ids");
    XCTAssertEqual([[registry sensorIdentifiers] count], (NSUInteger)0, @"No sensors should exist after registry has been cleared");
    XCTAssertNotNil([registry sensorLinksForSensorIdentifier:SENSOR_ID_12], @"Cleared registry should still return a collection of links for a non registered sensor");
    XCTAssertEqual([[registry sensorLinksForSensorIdentifier:SENSOR_ID_12] count], (NSUInteger)0, @"No components should be linked to a non existent sensor");
    XCTAssertNil([registry sensorWithIdentifier:SENSOR_ID_12], @"Registry should return nil for a non registered sensor identifier");
}

@end