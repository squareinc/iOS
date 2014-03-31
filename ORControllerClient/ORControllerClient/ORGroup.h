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

#import "ORWidget.h"

@class ORTabBar;
@class ORScreen;

/**
 * Model object representing a group element in the OR UI model domain.
 * name property is pre-populated with value coming from model.
 */
@interface ORGroup : ORWidget

/**
 * Collection of all screens that are part of this group.
 * This is an ordered collection.
 */
@property (nonatomic, strong, readonly) NSArray *screens;

/**
 * Tab bar belonging to this group.
 */
@property (nonatomic, strong, readonly) ORTabBar *tabBar;

/**
 * Get all screens whose orientation is portrait.
 * Order of screens in this collection is identical to the one on screens property.
 *
 * @return NSArray collection of screens with portrait orientation
 */
- (NSArray *)portraitScreens;

/**
 * Get all screens whose orientation is landscape.
 * Order of screens in this collection is identical to the one on screens property.
 *
 * @return NSArray collection of screens with landscape orientation
 */
- (NSArray *)landscapeScreens;

/**
 * Find a screen that is part of this group by its identifier. Returns nil if not found.
 *
 * @return ORScreen screen with given identifier or nil if none exists in this group
 */
- (ORScreen *)findScreenByIdentifier:(ORObjectIdentifier *)identifier;

@end