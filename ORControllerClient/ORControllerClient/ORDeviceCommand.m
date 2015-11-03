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

#import "ORDeviceCommand.h"
#import "ORDeviceCommand_Private.h"
#import "ORObjectIdentifier.h"
#import "ORDevice_Private.h"

static NSString *const KTagsKeys = @"self.internalTags";
static NSString *const kNameKey = @"name";
static NSString *const kIdentifierKey = @"identifier";
static NSString *const kProtocolKey = @"protocol";

@interface ORDeviceCommand ()

@property (nonatomic, strong) NSMutableSet *internalTags;

@end

@implementation ORDeviceCommand

@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize protocol = _protocol;
@synthesize device = _device;

- (void)addTag:(NSString *)tag
{
    if (tag) {
        [self.internalTags addObject:tag];
    }
}

#pragma mark - getters/setters

- (NSMutableSet *)internalTags
{
    if (!_internalTags) {
        _internalTags = [[NSMutableSet alloc] init];
    }
    return _internalTags;
}

- (NSSet *)tags
{
    return [self.internalTags copy];
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.internalTags = [coder decodeObjectForKey:KTagsKeys];
        _name = [coder decodeObjectForKey:kNameKey];
        _identifier = [coder decodeObjectForKey:kIdentifierKey];
        _protocol = [coder decodeObjectForKey:kProtocolKey];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.internalTags forKey:KTagsKeys];
    [coder encodeObject:self.name forKey:kNameKey];
    [coder encodeObject:self.identifier forKey:kIdentifierKey];
    [coder encodeObject:self.protocol forKey:kProtocolKey];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToCommand:other];
}

- (BOOL)isEqualToCommand:(ORDeviceCommand *)command
{
    if (self == command)
        return YES;
    if (command == nil)
        return NO;
    if (self.tags != command.tags && ![self.tags isEqualToSet:command.tags])
        return NO;
    if (self.internalTags != command.internalTags && ![self.internalTags isEqualToSet:command.internalTags])
        return NO;
    if (self.name != command.name && ![self.name isEqualToString:command.name])
        return NO;
    if (self.identifier != command.identifier && ![self.identifier isEqual:command.identifier])
        return NO;
    if (self.protocol != command.protocol && ![self.protocol isEqualToString:command.protocol])
        return NO;
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.tags hash];
    hash = hash * 31u + [self.internalTags hash];
    hash = hash * 31u + [self.name hash];
    hash = hash * 31u + [self.identifier hash];
    hash = hash * 31u + [self.protocol hash];
    hash = hash * 31u + [self.device hash];
    return hash;
}

@end
