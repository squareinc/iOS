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

@interface ORSensorLink ()

@property (nonatomic, strong, readwrite) NSObject *component;
@property (nonatomic, strong, readwrite) NSString *propertyName;

@end

@implementation ORSensorLink

- (id)initWithComponent:(NSObject *)aComponent propertyName:(NSString *)aPropertyName
{
    self = [super init];
    if (self) {
        self.component = aComponent;
        self.propertyName = aPropertyName;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ORSensorLink class]]) {
        return NO;
    }
    ORSensorLink *other = (ORSensorLink *)object;
    return ([other.component isEqual:self.component] &&
            [other.propertyName isEqualToString:self.propertyName]);
}

- (NSUInteger)hash
{
    return NSUINTROTATE([self.component hash], NSUINT_BIT / 2) ^ [self.propertyName hash];
}

@end