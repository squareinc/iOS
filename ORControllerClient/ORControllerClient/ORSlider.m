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

#import "ORSlider_Private.h"
#import "ORWidget_Private.h"
#import "ORImage_Private.h"
#import "Definition.h"

@interface ORSlider ()

@property(nonatomic, strong, readwrite) ORImage *thumbImage;
@property(nonatomic, readwrite) BOOL vertical;
@property(nonatomic, readwrite) BOOL passive;

@property (nonatomic) float _value;

@end

@implementation ORSlider

- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier vertical:(BOOL)verticalFlag passive:(BOOL)passiveFlag thumbImageSrc:(NSString *)thumbImageSrc
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.vertical = verticalFlag;
        self.passive = passiveFlag;
        if (thumbImageSrc) {
            self.thumbImage = [[ORImage alloc] initWithIdentifier:nil src:thumbImageSrc];
        }
		// Set default values for bounds, in case they're not explicitly set by parser
		self.minValue = 0.0;
		self.maxValue = 100.0;
    }
    return self;
}

- (void)setValue:(float)aValue
{
    if (!self.passive) {
        self._value = MIN(MAX(aValue, self.minValue), self.maxValue);
        [self.definition sendValue:self._value forSlider:self];
    }
}

- (float)value
{
    return self._value;
}

// Using a separate property to store the value received back from controller.
// This avoids looping because the setValue: method would send a command back to controller
// when it gets called by a status update.
// However, we must ensure that the KVO notification on property value is fired when there is a status update.

@synthesize _value;

- (void)set_value:(float)aValue
{
    [self willChangeValueForKey:@"value"];
    _value = aValue;
    [self didChangeValueForKey:@"value"];
}

@end