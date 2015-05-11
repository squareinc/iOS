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

#import "ORGroup.h"

@class ORObjectIdentifier;

@interface ORGroup ()

/**
 * Initializes the group with the given identifier and name.
 * Initialized group does not contain any screen.
 *
 * @param anIdentifier The identifier of the group
 * @param aName The name of the group
 *
 * @return an ORGroup object initialized with the provided values.
 */
- (instancetype)initWithGroupIdentifier:(ORObjectIdentifier *)anIdentifier name:(NSString *)aName;

/**
 * Adds the given screen to this group.
 * If a screen with the same identifier already exists, it is not added to the group.
 *
 * @param screen The screen to add to the group.
 */
- (void)addScreen:(ORScreen *)screen;

@property (nonatomic, strong, readwrite) ORTabBar *tabBar;

@end