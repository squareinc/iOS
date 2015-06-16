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
#import "ORTabBar_Private.h"
#import "ORTabBarItem.h"

#define kItemsKey       @"Items"

@interface ORTabBar ()

@property (nonatomic, strong) NSMutableArray *_items;

@end

@implementation ORTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
		self._items = [NSMutableArray array];
    }
    return self;
}

- (void)addItem:(ORTabBarItem *)item
{
    [self._items addObject:item];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:self._items];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self._items forKey:kItemsKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self._items = [aDecoder decodeObjectForKey:kItemsKey];
    }
    return self;
}

@synthesize _items;

@end