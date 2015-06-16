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

#import "ORBackground_Private.h"

#define kImageKey        @"Image"
#define kRepeatKey       @"Repeat"
#define kPositionXKey    @"PositionX"
#define kPositionYKey    @"PositionY"
#define kPositionUnitKey @"PositionUnit"
#define kSizeWidthKey    @"SizeWidth"
#define kSizeHeightKey   @"SizeHeight"
#define kSizeUnitKey     @"SizeUnit"

@implementation ORBackground

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.repeat = ORBackgroundRepeatNoRepeat;
        self.positionUnit = ORWidgetUnitNotDefined;
        self.sizeUnit = ORWidgetUnitNotDefined;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:kImageKey];
    [aCoder encodeInteger:self.repeat forKey:kRepeatKey];
    [aCoder encodeInteger:self.position.x forKey:kPositionXKey];
    [aCoder encodeInteger:self.position.y forKey:kPositionYKey];
    [aCoder encodeInteger:self.positionUnit forKey:kPositionUnitKey];
    [aCoder encodeInteger:self.size.width forKey:kSizeWidthKey];
    [aCoder encodeInteger:self.size.height forKey:kSizeHeightKey];
    [aCoder encodeInteger:self.sizeUnit forKey:kSizeUnitKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.image = [aDecoder decodeObjectForKey:kImageKey];
        self.repeat = [aDecoder decodeIntegerForKey:kRepeatKey];
        self.position = CGPointMake([aDecoder decodeIntegerForKey:kPositionXKey], [aDecoder decodeIntegerForKey:kPositionYKey]);
        self.positionUnit = [aDecoder decodeIntegerForKey:kPositionUnitKey];
        self.size = CGSizeMake([aDecoder decodeIntegerForKey:kSizeWidthKey], [aDecoder decodeIntegerForKey:kSizeHeightKey]);
        self.sizeUnit = [aDecoder decodeIntegerForKey:kSizeUnitKey];
    }
    return self;
}

@end