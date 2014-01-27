/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
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
#import "ORSensorState.h"

@interface ORSensorState ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *value;

@end

@implementation ORSensorState

- (id)initWithName:(NSString *)sensorName value:(NSString *)sensorValue
{
    if (!sensorName) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.name = sensorName;
        self.value = sensorValue;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ORSensorState class]]) {
        return NO;
    }
    ORSensorState *other = (ORSensorState *)object;
    if (other.name != self.name && ![other.name isEqualToString:self.name]) {
        return NO;
    }
    if (other.value != self.value && ![other.value isEqualToString:self.value]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return NSUINTROTATE([self.name hash], NSUINT_BIT / 2) ^ [self.value hash];
}

@synthesize name;
@synthesize value;

@end