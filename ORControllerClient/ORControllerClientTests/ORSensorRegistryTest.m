//
//  ORStatusRegistryTest.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 01/08/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

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