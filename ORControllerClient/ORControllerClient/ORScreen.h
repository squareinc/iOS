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
#import "ORGesture.h"

@class ORBackground;

#import <UIKit/UIKit.h>

/**
 * The orientation of the screen.
 */
typedef NS_ENUM(NSUInteger, ORScreenOrientation) {
    /**
     * Screen in portrait orientation.
     */
    ORScreenOrientationPortrait,
    /**
     * Screen in landscape orientation.
     */
    ORScreenOrientationLandscape
};

/**
 * Model object representing a screen element in the OR UI model domain.
 * name property is pre-populated with value coming from model.
 */
@interface ORScreen : ORWidget <NSCoding>

/**
 * Get gesture of given type, if any registered with this screen.
 *
 * @param type The type of the gesture to return.
 *
 * @return ORGesture gesture of the given type, or nil if none is registered with this screen
 */
- (ORGesture *)gestureForType:(ORGestureType)type;

/**
 * Returns the screen appropriate to display content in the given orientation.
 * If a screen cannot be found for the orientation, the receiver is returned.
 *
 * @param anOrientation The desired screen orientation.
 *
 * @return ORScreen screen in given orientation or self if none exists
 */
- (ORScreen *)screenForOrientation:(ORScreenOrientation)anOrientation;

/**
 * Orientation of the screen: portrait or lanscape.
 */
@property (nonatomic, readonly) ORScreenOrientation orientation;

/**
 * Screen that represents that same content in the other orientation.
 * Nil if none is defined.
 */
@property (nonatomic, strong, readonly) ORScreen *rotatedScreen;

/**
 * Background of the screen.
 */
@property (nonatomic, strong, readonly) ORBackground *background;

/**
 * Collection of layouts that do define the content of this screen.
 * This is an ordered collection.
 * Objects in the collection are subclasses of ORLayoutContainer.
 */
@property (nonatomic, strong, readonly) NSArray *layouts;

/**
 * Collection of gestures that are registered on this screen.
 */
@property (nonatomic, strong, readonly) NSArray *gestures;

@end
