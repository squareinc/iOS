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

#import "ORGroup_Private.h"
#import "ORWidget_Private.h"
#import "ORScreen.h"

@interface ORGroup ()

@property (nonatomic, copy, readwrite) NSString *name;

@property (nonatomic, strong, readwrite) NSMutableArray *_screens;

@end

@implementation ORGroup

- (instancetype)initWithGroupIdentifier:(ORObjectIdentifier *)anIdentifier name:(NSString *)aName
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.name = aName;
        self._screens = [NSMutableArray array];
    }
    return self;
}

- (void)addScreen:(ORScreen *)screen
{
    [self._screens addObject:screen];
}

- (NSArray *)screens
{
    return [NSArray arrayWithArray:self._screens];
}

- (NSArray *)portraitScreens
{
    return [self._screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"orientation == %d", ORScreenOrientationPortrait]];
}

- (NSArray *)landscapeScreens
{
    return [self._screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"orientation == %d", ORScreenOrientationLandscape]];
}

- (ORScreen *)findScreenByIdentifier:(ORObjectIdentifier *)identifier
{
	NSArray *ss = [self._screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"identifier == %@", identifier]];
    return [ss lastObject];
}

@synthesize tabBar;

@end