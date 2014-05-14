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

#import <Foundation/Foundation.h>

@class Definition;
@class ScreenReference;
@class ORGroup;
@class ORScreen;

/**
 * Handles navigation, management of its history and persistence of it.
 * The NavigationManager is responsible for deciding on all possible navigations
 * and conducting them.
 * It keeps a history of the navigation, with its top being the group/screen currently displayed,
 * which can always be queried.
 * It ensures that the references it returns are always valid based on the definition it knows about.
 */
@interface NavigationManager : NSObject

/**
 * Reloads appropriate history for this definition.
 */
- (instancetype)initWithDefinition:(Definition *)aDefinition;

/**
 * Returns the screen reference of the screen we're currently on.
 * Takes persisted history into account.
 * Ensures group / screen reference is valid for definition.
 * Returns nil, if definition contains no group at all or only groups with no screen.
 */
- (ScreenReference *)currentScreenReference;



- (ScreenReference *)navigateToGroup:(ORGroup *)group toScreen:(ORScreen *)screen;
- (ScreenReference *)navigateToPreviousScreen;
- (ScreenReference *)navigateToNextScreen;
- (ScreenReference *)back;

@end