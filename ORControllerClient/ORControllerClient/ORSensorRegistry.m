//
//  ORSensorRegistry.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 01/08/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORSensorRegistry.h"
#import "Sensor.h"

@interface ORSensorRegistry ()

@property (nonatomic, strong) NSMutableSet *_sensors;
@property (nonatomic, strong) NSMutableDictionary *_componentsPerSensorId;

@end

// TODO: in a later version, the link is not only to 1 component but also to a specific property of a component

@implementation ORSensorRegistry

- (id)init
{
    self = [super init];
    if (self) {
        self._sensors = [NSMutableSet set];
        self._componentsPerSensorId = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearRegistry
{
    [self._componentsPerSensorId removeAllObjects];
    [self._sensors removeAllObjects];
}

- (void)registerSensor:(Sensor *)sensor linkedToComponent:(NSObject *)component
{
    [self._sensors addObject:sensor];
    NSMutableArray *components = [self._componentsPerSensorId objectForKey:[NSNumber numberWithInt:sensor.sensorId]];
    if (!components) {
        components = [NSMutableArray arrayWithCapacity:1];
        [self._componentsPerSensorId setObject:components forKey:[NSNumber numberWithInt:sensor.sensorId]];
    }
    [components addObject:component];
}

- (NSSet *)componentsLinkedToSensorId:(NSNumber *)sensorId
{
    return [NSSet setWithArray:[self._componentsPerSensorId objectForKey:sensorId]];
}

- (NSSet *)sensorIds
{
    NSMutableSet *allIds = [NSMutableSet setWithCapacity:[self._sensors count]];
    [self._sensors enumerateObjectsUsingBlock:^(Sensor *sensor, BOOL *stop) {
        [allIds addObject:[NSNumber numberWithInt:sensor.sensorId]];
    }];
    
    return allIds;
}

@end
