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

typedef NS_ENUM(NSUInteger, ORScreenOrientation) {
    ORScreenOrientationPortrait,
    ORScreenOrientationLandscape
};

@interface ORScreen : ORWidget

/**
 * Get gesture of given type, if any registered with this screen.
 */
- (ORGesture *)gestureForType:(ORGestureType)type;

- (ORScreen *)screenForOrientation:(ORScreenOrientation)anOrientation;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) ORScreenOrientation orientation;
@property (nonatomic, strong, readonly) ORScreen *rotatedScreen;

@property (nonatomic, strong, readonly) ORBackground *background;
@property (nonatomic, strong, readonly) NSArray *layouts;
@property (nonatomic, strong, readonly) NSArray *gestures;

@end
