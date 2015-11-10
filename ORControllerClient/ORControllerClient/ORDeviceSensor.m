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

#import "ORDeviceSensor_Private.h"
#import "ORObjectIdentifier.h"
#import "ORDevice.h"
#import "ORDeviceCommand.h"
#import "ORDeviceCommand_Private.h"

static NSString *const kIdentifierKey = @"identifier";
static NSString *const kNameKey = @"name";
static NSString *const kTypeKey = @"type";
static NSString *const kCommandIdentifierKey = @"commandIdentifier";

@implementation ORDeviceSensor

@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize type = _type;
@synthesize device = _device;
@synthesize command = _command;
@synthesize value = _value;

#pragma mark - getter/setters

- (ORObjectIdentifier *)commandIdentifier
{
    if (self.command) {
        _commandIdentifier = self.command.identifier;
    }
    return _commandIdentifier;
}

- (void)setCommand:(ORDeviceCommand *)command
{
    _command = command;
    _commandIdentifier = command.identifier;
}


#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _identifier = [coder decodeObjectForKey:kIdentifierKey];
        _name = [coder decodeObjectForKey:kNameKey];
        _type = (SensorType) [coder decodeIntForKey:kTypeKey];
        _commandIdentifier = [coder decodeObjectForKey:kCommandIdentifierKey];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.identifier forKey:kIdentifierKey];
    [coder encodeObject:self.name forKey:kNameKey];
    [coder encodeInt:self.type forKey:kTypeKey];
    [coder encodeObject:self.commandIdentifier forKey:kCommandIdentifierKey];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToSensor:other];
}

- (BOOL)isEqualToSensor:(ORDeviceSensor *)sensor
{
    if (self == sensor)
        return YES;
    if (sensor == nil)
        return NO;
    if (self.identifier != sensor.identifier && ![self.identifier isEqual:sensor.identifier])
        return NO;
    if (self.name != sensor.name && ![self.name isEqualToString:sensor.name])
        return NO;
    if (self.type != sensor.type)
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.name hash];
    hash = hash * 31u + (NSUInteger) self.type;
    hash = hash * 31u + [self.device hash];
    hash = hash * 31u + [self.command hash];
    return hash;
}

@end
