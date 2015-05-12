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

#import "ORScreenOrGroupReference.h"
#import "ORControllerClient/ORObjectIdentifier.h"

@interface ORScreenOrGroupReference ()

@property (copy, readwrite) ORObjectIdentifier *groupIdentifier;
@property (copy, readwrite) ORObjectIdentifier *screenIdentifier;

@end

#define kGroupIdentifierKey @"GroupIdentifier"
#define kScreenIdentifierKey @"ScreenIdentifier"

@implementation ORScreenOrGroupReference

- (id)initWithGroupIdentifier:(ORObjectIdentifier *)aGroupdIdentifier screenIdentifier:(ORObjectIdentifier *)aScreenIdentifier
{
    if (!aGroupdIdentifier) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.groupIdentifier = aGroupdIdentifier;
        self.screenIdentifier = aScreenIdentifier;
    }
    return self;
}

- (BOOL)isEqualToScreenReference:(ORScreenOrGroupReference *)aScreenReference
{
    if (![self.groupIdentifier isEqual:aScreenReference.groupIdentifier]) {
        return NO;
    }
    
    if (!self.screenIdentifier && !aScreenReference.screenIdentifier) {
        return YES;
    }
    
    return [self.screenIdentifier isEqual:aScreenReference.screenIdentifier];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[ORScreenOrGroupReference class]]) {
        return NO;
    }
    return [self isEqualToScreenReference:(ORScreenOrGroupReference *)object];
}

- (NSUInteger)hash
{
    return NSUINTROTATE([self.groupIdentifier hash], NSUINT_BIT / 2) ^ [self.screenIdentifier hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithGroupIdentifier:[self.groupIdentifier copyWithZone:zone]
                                                     screenIdentifier:[self.screenIdentifier copyWithZone:zone]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.groupIdentifier forKey:kGroupIdentifierKey];
    [aCoder encodeObject:self.screenIdentifier forKey:kScreenIdentifierKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    ORObjectIdentifier *groupId = [aDecoder decodeObjectForKey:kGroupIdentifierKey];
    ORObjectIdentifier *screenId = [aDecoder decodeObjectForKey:kScreenIdentifierKey];
    return [self initWithGroupIdentifier:groupId screenIdentifier:screenId];
}

@end