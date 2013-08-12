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
#import "ORSensorLink.h"
#import "Sensor.h"

@interface ORSensorRegistry ()

@property (nonatomic, strong) NSMutableSet *_sensors;
@property (nonatomic, strong) NSMutableDictionary *_sensorsPerId;
@property (nonatomic, strong) NSMutableDictionary *_linksPerSensorId;

@end

@implementation ORSensorRegistry

- (id)init
{
    self = [super init];
    if (self) {
        self._sensors = [NSMutableSet set];
        self._linksPerSensorId = [NSMutableDictionary dictionary];
        self._sensorsPerId = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearRegistry
{
    [self._linksPerSensorId removeAllObjects];
    [self._sensorsPerId removeAllObjects];
    [self._sensors removeAllObjects];
}

- (void)registerSensor:(Sensor *)sensor linkedToComponent:(NSObject *)component property:(NSString *)propertyName
{
    [self._sensors addObject:sensor];
    [self._sensorsPerId setObject:sensor forKey:[NSNumber numberWithInt:sensor.sensorId]];
    NSMutableArray *components = [self._linksPerSensorId objectForKey:[NSNumber numberWithInt:sensor.sensorId]];
    if (!components) {
        components = [NSMutableSet setWithCapacity:1];
        [self._linksPerSensorId setObject:components forKey:[NSNumber numberWithInt:sensor.sensorId]];
    }
    [components addObject:[[ORSensorLink alloc] initWithComponent:component propertyName:propertyName]];
}

- (NSSet *)sensorLinksForSensorId:(NSNumber *)sensorId
{
    return [NSSet setWithSet:[self._linksPerSensorId objectForKey:sensorId]];
}

- (Sensor *)sensorWithId:(NSNumber *)sensorId
{
    return [self._sensorsPerId objectForKey:sensorId];
}

- (NSSet *)sensorIds
{
    return [NSSet setWithArray:[self._sensorsPerId allKeys]];
}

@end
