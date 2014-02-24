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

#import "ScreenReferenceStack.h"

@interface ScreenReferenceStack ()

@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic) int capacity;

@end

@implementation ScreenReferenceStack

- (id)initWithCapacity:(int)aCapacity
{
    self = [super init];
    if (self) {
        self.capacity = aCapacity;
        self.stack = [NSMutableArray arrayWithCapacity:self.capacity];
    }
    return self;
}

- (void)push:(ScreenReference *)screen
{
    // We should never be over capacity, but this code would take care of that situation also
    while ([self.stack count] >= self.capacity) {
        [self.stack removeObjectAtIndex:0];
    }
    [self.stack addObject:screen];
}

- (ScreenReference *)pop
{
    if (![self.stack count]) {
        return nil;
    }
    ScreenReference *ref = [self.stack lastObject];
    [self.stack removeLastObject];
    return ref;
}

@end