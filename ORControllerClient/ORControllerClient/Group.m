/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "Group.h"
#import "Definition.h"

@interface Group ()

@property (nonatomic, readwrite) int groupId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSMutableArray *screens;

@end

@implementation Group

- (id)initWithGroupId:(int)anId name:(NSString *)aName
{
    self = [super init];
    if (self) {
        self.groupId = anId;
        self.name = aName;
		self.screens = [NSMutableArray array];
    }
    return self;
}

// Get all portrait screens in group.
- (NSArray *) getPortraitScreens {
	return [self.screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"orientation == %d", ORScreenOrientationPortrait]];
}

// Get all landscape screens in group.
- (NSArray *) getLandscapeScreens {
	return [self.screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"orientation == %d", ORScreenOrientationLandscape]];
}

// Find screen model in specified orientation screens of group containing by screen id.
- (BOOL)doesExistScreenWithIdentifier:(ORObjectIdentifier *)identifier orientation:(ORScreenOrientation)orientation
{
	return [self.screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"orientation == %d && identifier == %@", orientation, identifier]].count > 0;
}

- (ORScreen *) findScreenByScreenIdentifier:(ORObjectIdentifier *)identifier {
	NSArray *ss = [self.screens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"identifier == %@", identifier]];
	if (ss.count > 0) {
		ORScreen *screen = [ss objectAtIndex:0];
		return screen;
	}
	return nil;
}

@synthesize groupId, name, screens, tabBar;

@end