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

#import "ORSwitch_Private.h"
#import "Definition.h"
#import "ORImage.h"

#define kOnImageKey     @"OnImage"
#define kOffImageKey    @"OffImage"
#define kStateKey       @"State"

@interface ORSwitch ()

@property (nonatomic, readwrite) BOOL _state;

@end

@implementation ORSwitch

- (void)toggle
{
    if (self.state) {
        [self.definition sendOffForSwitch:self];
    } else {
        [self.definition sendOnForSwitch:self];
    }
}

- (void)on
{
    if (!self.state) {
        [self.definition sendOnForSwitch:self];
    }
}

- (void)off
{
    if (self.state) {
        [self.definition sendOffForSwitch:self];
    }
}

- (void)setState:(NSString *)stateAsString
{
    // If state mapping is defined on the switch, the received value is the translated one, not the original
    if (self.onImage) {
        self._state = [self.onImage.src isEqualToString:stateAsString];
    } else {
        self._state = [@"on" isEqualToString:[stateAsString lowercaseString]];
    }
}

- (BOOL)state
{
    return self._state;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.onImage forKey:kOnImageKey];
    [aCoder encodeObject:self.offImage forKey:kOffImageKey];
    [aCoder encodeBool:self._state forKey:kStateKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.onImage = [aDecoder decodeObjectForKey:kOnImageKey];
        self.offImage = [aDecoder decodeObjectForKey:kOffImageKey];
        self._state = [aDecoder decodeBoolForKey:kStateKey];
    }
    return self;
}

@end