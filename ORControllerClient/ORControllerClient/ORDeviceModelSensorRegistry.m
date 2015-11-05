/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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
#import "ORDeviceModelSensorRegistry.h"
#import "ORSensor.h"
#import "ORObjectIdentifier.h"
#import "ORDeviceSensor_Private.h"
#import "UIColor+ORAdditions.h"

#define kDeviceSensorsPerSensorIdKey  @"DeviceSensorsPerSensorId"

@interface ORDeviceModelSensorRegistry ()

@property (nonatomic, strong) NSMutableDictionary *_deviceSensorsPerSensorId;

@end

@implementation ORDeviceModelSensorRegistry

- (instancetype)init
{
    self = [super init];
    if (self) {
        self._deviceSensorsPerSensorId = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearRegistry
{
    [self._deviceSensorsPerSensorId removeAllObjects];
    [super clearRegistry];
}

- (void)registerSensor:(ORSensor *)sensor linkedToORDeviceSensor:(ORDeviceSensor *)deviceSensor
{
    [super registerSensor:sensor];
    NSMutableSet *deviceSensors = [self._deviceSensorsPerSensorId objectForKey:sensor.identifier];
    if (!deviceSensors) {
        deviceSensors = [NSMutableSet setWithCapacity:1];
        [self._deviceSensorsPerSensorId setObject:deviceSensors forKey:sensor.identifier];
    }
    [deviceSensors addObject:deviceSensor];
}

- (void)updateWithSensorValues:(NSDictionary *)sensorValues
{
    // Update properties of linked element
    [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
        ORObjectIdentifier *sensorIdentifier = [[ORObjectIdentifier alloc] initWithStringId:sensorId];
        NSSet *deviceSensors = [self._deviceSensorsPerSensorId objectForKey:sensorIdentifier];
        
        [deviceSensors enumerateObjectsUsingBlock:^(ORDeviceSensor *deviceSensor, BOOL *stop) {
            switch(deviceSensor.type) {
                case SensorTypeSwitch:
                {
                    deviceSensor.value = [NSNumber numberWithBool:[@"on" isEqualToString:sensorValue]];
                    break;
                }
                case SensorTypeLevel:
                case SensorTypeRange:
                {
                    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                    decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                    deviceSensor.value = [decimalFormatter numberFromString:sensorValue];
                    break;
                }
                case SensorTypeColor:
                {
                    [UIColor or_ColorWithRGBString:sensorValue];
                    break;
                }
                default:
                    deviceSensor.value = sensorValue;
            }
        }];
    }];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self._deviceSensorsPerSensorId forKey:kDeviceSensorsPerSensorIdKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self._deviceSensorsPerSensorId = [aDecoder decodeObjectForKey:kDeviceSensorsPerSensorIdKey];
    }
    return self;
}

@end
