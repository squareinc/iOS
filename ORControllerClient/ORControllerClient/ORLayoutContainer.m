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
#import "ORLayoutContainer.h"

#define kLeftKey       @"Left"
#define kTopKey        @"Top"
#define kWidthKey      @"Width"
#define kHeightKey     @"Height"

@interface ORLayoutContainer ()

@property (nonatomic, readwrite) NSInteger left;
@property (nonatomic, readwrite) NSInteger top;
@property (nonatomic, readwrite) NSUInteger width;
@property (nonatomic, readwrite) NSUInteger height;

@end

@implementation ORLayoutContainer

- (NSSet *)widgets
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.left forKey:kLeftKey];
    [aCoder encodeInteger:self.top forKey:kTopKey];
    [aCoder encodeInteger:self.width forKey:kWidthKey];
    [aCoder encodeInteger:self.height forKey:kHeightKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.left = [aDecoder decodeIntegerForKey:kLeftKey];
        self.top = [aDecoder decodeIntegerForKey:kTopKey];
        self.width = [aDecoder decodeIntegerForKey:kWidthKey];
        self.height = [aDecoder decodeIntegerForKey:kHeightKey];
    }
    return self;
}

@synthesize left, top, width, height;

@end