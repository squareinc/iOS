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
#import "ORGridCell_Private.h"

#define kWidgetKey       @"Widget"
#define kXKey            @"X"
#define kYKey            @"Y"
#define kRowSpanKey      @"RowSpan"
#define kColSpanKey      @"ColSpan"

@interface ORGridCell ()

@property (nonatomic, readwrite) NSUInteger x;
@property (nonatomic, readwrite) NSUInteger y;
@property (nonatomic, readwrite) NSUInteger rowspan;
@property (nonatomic, readwrite) NSUInteger colspan;

@end

@implementation ORGridCell

- (instancetype)initWithX:(NSUInteger)xPos y:(NSUInteger)yPos rowspan:(NSUInteger)rowspanValue colspan:(NSUInteger)colspanValue
{
    self = [super init];
    if (self) {
        self.x = xPos;
        self.y = yPos;
        self.rowspan = MAX(1, rowspanValue);
        self.colspan = MAX(1, colspanValue);
    }
    return self;    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.widget forKey:kWidgetKey];
    [aCoder encodeInteger:self.x forKey:kXKey];
    [aCoder encodeInteger:self.y forKey:kYKey];
    [aCoder encodeInteger:self.rowspan forKey:kRowSpanKey];
    [aCoder encodeInteger:self.colspan forKey:kColSpanKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.widget = [aDecoder decodeObjectForKey:kWidgetKey];
        self.x = [aDecoder decodeIntegerForKey:kXKey];
        self.y = [aDecoder decodeIntegerForKey:kYKey];
        self.rowspan = [aDecoder decodeIntegerForKey:kRowSpanKey];
        self.colspan = [aDecoder decodeIntegerForKey:kColSpanKey];
    }
    return self;
}

@synthesize x,y,rowspan,colspan,widget;

@end