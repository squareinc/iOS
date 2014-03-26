/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "ClientSideProtocolReadCommandBase.h"
#import "ClientSideRuntime.h"
#import "SensorStatusCache.h"
#import "ORControllerClient/LocalSensor.h"

@interface ClientSideProtocolReadCommandBase ()

@property (nonatomic, strong) NSMutableSet *sensorIds;
@property (nonatomic, strong) ClientSideRuntime *clientSideRuntime;

- (void)startUpdating;
- (void)stopUpdating;
- (NSString *)sensorValue;

@end

@implementation ClientSideProtocolReadCommandBase

- (id)initWithRuntime:(ClientSideRuntime *)runtime
{
    self = [super init];
    if (self) {
        self.sensorIds = [NSMutableSet set];
        self.clientSideRuntime = runtime;
    }
    return self;
}


- (void)startUpdatingSensor:(LocalSensor *)sensor
{
    if (![self.sensorIds count]) {
        [self startUpdating];
    }
    [self.clientSideRuntime.sensorStatusCache publishNewValue:[self sensorValue] forSensorIdentifier:sensor.identifier];
    [self.sensorIds addObject:sensor.identifier];
}

- (void)stopUpdatingSensor:(LocalSensor *)sensor
{
    [self.sensorIds removeObject:sensor.identifier];
    if (![self.sensorIds count]) {
        [self stopUpdating];
    }
}

- (void)publishValue
{
    NSString *sensorValue = [self sensorValue];
    for (ORObjectIdentifier *sensorIdentifier in self.sensorIds) {
        [self.clientSideRuntime.sensorStatusCache publishNewValue:sensorValue forSensorIdentifier:sensorIdentifier];
    }
}

- (void)startUpdating
{
    // To be implemented by subclasses
}

- (void)stopUpdating
{
    // To be implemented by subclasses
}

- (NSString *)sensorValue
{
    // To be implemented by subclasses
    return @"";
}

@synthesize sensorIds;
@synthesize clientSideRuntime;

@end