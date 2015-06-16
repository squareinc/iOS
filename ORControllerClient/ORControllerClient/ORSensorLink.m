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

#import "ORSensorLink.h"
#import "ORSensorStatesMapping.h"

#define kComponentKey            @"Component"
#define kPropertyNameKey         @"PropertyName"
#define kSensorStatesMappingKey  @"SensorStatesMapping"

@interface ORSensorLink ()

@property (nonatomic, strong, readwrite) NSObject *component;
@property (nonatomic, strong, readwrite) NSString *propertyName;
@property (nonatomic, strong, readwrite) ORSensorStatesMapping *sensorStatesMapping;

@end

@implementation ORSensorLink

- (instancetype)initWithComponent:(NSObject *)aComponent
                     propertyName:(NSString *)aPropertyName
              sensorStatesMapping:(ORSensorStatesMapping *)mapping
{
    self = [super init];
    if (self) {
        self.component = aComponent;
        self.propertyName = aPropertyName;
        self.sensorStatesMapping = mapping;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ORSensorLink class]]) {
        return NO;
    }
    ORSensorLink *other = (ORSensorLink *)object;
    if (other.component != self.component && ![other.component isEqual:self.component]) {
        return NO;
    }
    if (other.propertyName != self.propertyName && ![other.propertyName isEqualToString:self.propertyName]) {
        return NO;
    }
    if (other.sensorStatesMapping != self.sensorStatesMapping && ![other.sensorStatesMapping isEqual:self.sensorStatesMapping]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return NSUINTROTATE([self.sensorStatesMapping hash], NSUINT_BIT / 2)
                ^ NSUINTROTATE([self.component hash], NSUINT_BIT / 2)
                ^ [self.propertyName hash];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.component forKey:kComponentKey];
    [aCoder encodeObject:self.propertyName forKey:kPropertyNameKey];
    [aCoder encodeObject:self.sensorStatesMapping forKey:kSensorStatesMappingKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithComponent:[aDecoder decodeObjectForKey:kComponentKey]
                      propertyName:[aDecoder decodeObjectForKey:kPropertyNameKey]
               sensorStatesMapping:[aDecoder decodeObjectForKey:kSensorStatesMappingKey]];
}

@synthesize component;
@synthesize propertyName;
@synthesize sensorStatesMapping;

@end