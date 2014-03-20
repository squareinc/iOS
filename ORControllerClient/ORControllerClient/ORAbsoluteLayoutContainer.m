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
#import "ORAbsoluteLayoutContainer.h"
#import "SensorComponent.h"
#import "Sensor.h"

@interface ORAbsoluteLayoutContainer ()

@property (nonatomic, readwrite) NSInteger left;
@property (nonatomic, readwrite) NSInteger top;
@property (nonatomic, readwrite) NSUInteger width;
@property (nonatomic, readwrite) NSUInteger height;

@end

@implementation ORAbsoluteLayoutContainer

- (id)initWithLeft:(NSInteger)leftPos
               top:(NSInteger)topPos
             width:(NSUInteger)widthDim
            height:(NSUInteger)heightDim
{
    self = [super init];
    if (self) {
        self.left = leftPos;
        self.top = topPos;
        self.width = widthDim;
        self.height = heightDim;
    }
    return self;
}

- (NSSet *)components
{
    return [NSSet setWithObject:self.component];
}

@synthesize component;
@synthesize left, top, width, height;

@end