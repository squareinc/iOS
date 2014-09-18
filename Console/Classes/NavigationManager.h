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
 * and conducting them (on the stack, not visually).
 * It keeps a history of the navigation, with its top being the group/screen currently displayed,
 * which can always be queried.
 * It ensures that the references it returns are always valid based on the definition it knows about.
 */
@interface NavigationManager : NSObject

/**
 * Initializes a navigation manager with the given definition.
 *
 * Loads the persisted navigation history for this definition
 * and makes sure the currentScreenReference is valid within this definition.
 *
 * @param aDefinition Definition on which the navigation manager will work.
 *
 * @return A NavigationManager object initialized with given definition. If no definition was given, returns nil.
 */
- (instancetype)initWithDefinition:(Definition *)aDefinition;

/**
 * Returns the screen reference of the screen we're currently on.
 * Takes persisted history into account.
 * Ensures group / screen reference is valid for definition.
 * Returns nil, if definition contains no group at all or only groups with no screen.
 *
 * @return A ScreenReference representing the screen we're currently on, or nil if no valid one exists.
 */
- (ScreenReference *)currentScreenReference;

/**
 * Navigates to the given group and screen.
 * Returns the ScreenReference representing the destination screen and pushes it on top of the navigation stack,
 * in effect making in the currentScreenReference.
 * Persists the navigation history.
 *
 * If the requested group does not exist or the requested screen does not exist, no navigation is performed and nil is returned.
 * If no screen is specified, the first screen in the group is used.
 * If the group does not contain any screen, no navigation is performed and nil is returned.
 *
 * @return A ScreenReference representing the target screen of the navigation, or nil if the navigation can't be performed.
 */
- (ScreenReference *)navigateToGroup:(ORGroup *)group toScreen:(ORScreen *)screen;

/**
 * Navigates to the previous screen in the current group.
 * Returns the ScreenReference representing the destination screen and pushes it on top of the navigation stack,
 * in effect making in the currentScreenReference.
 * Persists the navigation history.
 *
 * If the screen is already the first in the group, no navigation is performed and nil is returned.
 * If there is no current group, no navigation is performed and nil is returned.
 *
 * @return A ScreenReference representing the target screen of the navigation, or nil if the navigation can't be performed.
 */
- (ScreenReference *)navigateToPreviousScreen;

/**
 * Navigates to the next screen in the current group.
 * Returns the ScreenReference representing the destination screen and pushes it on top of the navigation stack,
 * in effect making in the currentScreenReference.
 * Persists the navigation history.
 *
 * If the screen is already the last in the group, no navigation is performed and nil is returned.
 * If there is no current group, no navigation is performed and nil is returned.
 *
 * @return A ScreenReference representing the target screen of the navigation, or nil if the navigation can't be performed.
 */
- (ScreenReference *)navigateToNextScreen;

/**
 * Goes back the navigation history and navigates to the previously current screen.
 * Persists the navigation history.
 *
 * If there is no previous state in the navigation history, returns the current screen reference.
 * If the previous state on the navigation history is not valid anymore, goes back further in history
 * until a valid state is found.
 * If no valid state can be found, the history is cleared, the current screen reference is returned
 * and becomes the sole item in the naviation history.
 *
 * @return A ScreenReference representing the target screen of the navigation.
 */
- (ScreenReference *)back;

@end