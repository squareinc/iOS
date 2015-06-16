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

#import "ORNavigation.h"

@class ORGroup;
@class ORScreen;

/**
 * Model object representing a navigation to a given group or screen.
 * Its navigation type is always ORNavigationTypeToGroupOrScreen
 */
@interface ORScreenNavigation : ORNavigation <NSCoding>

/**
 * Group navigation goes to.
 * If no group is specified, navigation occurs within the current group.
 */
@property (nonatomic, strong, readonly) ORGroup *destinationGroup;

/**
 * Screen navigation goes to.
 * If no screen is specified, navigation goes to first screen in destination Group.
 */
@property (nonatomic, strong, readonly) ORScreen *destinationScreen;

@end