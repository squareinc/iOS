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

typedef NS_ENUM(NSInteger, ORGestureType) {
    ORGestureTypeSwipeBottomToTop  = 0,
	ORGestureTypeSwipeLeftToRight  = 1,
	ORGestureTypeSwipeTopToBottom  = 2,
	ORGestureTypeSwipeRightToLeft  = 3
};

@interface ORGesture : ORWidget

@property (nonatomic, readonly) ORGestureType gestureType;

- (void)perform;

@end