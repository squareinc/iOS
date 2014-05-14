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

@class ScreenReference;

/**
 * Stack of ScreenReference objects, used to manage the history of navigation within the application.
 * Size is limited to a certain number of items, older ones are discarded when stack is full.
 */
@interface ScreenReferenceStack : NSObject

/**
 * Initializes a stack of ScreenReference objects with given capacity.
 *
 * @param aCapacity number of items that the stack is able to contain
 *
 * @return A ScreenReferenceStack object initialized with the given capacity.
 */
- (id)initWithCapacity:(int)aCapacity;

/**
 * Pushes the given reference to the top of the stack.
 * If the stack has reached capacity, the item at the bottom of the stack
 * (oldest pushed) is discarded first.
 *
 * @param screen reference to be pushed to the top of the stack
 */
- (void)push:(ScreenReference *)screen;

/**
 * Removes the reference from the top of the stack and returns it (if there is one).
 *
 * @return ScreenReference the reference at the top of the stack, or nil if stack is empty
 */
- (ScreenReference *)pop;

/**
 * Returns the reference from the top of the stack (if there is one), without removing it.
 *
 * @return ScreenReference the reference at the top of the stack, or nil if stack is empty
 */
- (ScreenReference *)top;

@end