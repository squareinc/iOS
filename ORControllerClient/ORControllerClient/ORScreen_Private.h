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

#import "ORScreen.h"

@class ORObjectIdentifier;
@class ORLayoutContainer;

@interface ORScreen ()

@property (nonatomic, strong, readwrite) ORScreen *rotatedScreen;
@property (nonatomic, strong, readwrite) ORBackground *background;

/**
 * Initializes the screen with the given identifier, name and orientation.
 * Initialized group does not contain any layouts.
 *
 * @param anIdentifier identifier of the screen
 * @param aName name of the screen
 * @param anOrientation orientation of the screen
 *
 * @return an ORScreen object initialized with the provided values.
 */
- (instancetype)initWithScreenIdentifier:(ORObjectIdentifier *)anIdentifier
                          name:(NSString *)aName
                   orientation:(ORScreenOrientation)anOrientation;

/**
 * Adds the given gesture to this group.
 * If a gesture with the same identifier already exists, it is not added to the screen.
 *
 * @param ORGesture gesture to add to the screen.
 */
- (void)addGesture:(ORGesture *)gesture;

/**
 * Adds the given layout to this screen.
 *
 * @param ORLayoutContainer layout to add to the screen.
 */
- (void)addLayout:(ORLayoutContainer *)layout;

@end