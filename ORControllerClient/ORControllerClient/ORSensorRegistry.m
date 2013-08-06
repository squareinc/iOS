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
