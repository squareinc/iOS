/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

@class ORControllerAddress;

/**
 * Represents an OpenRemote ORB
 */
@interface ORController : NSObject

- (id)initWithControllerAddress:(ORControllerAddress *)anAddress;

// Q: methods for explicit connection management : connect, disconnect, isConnected ?
// Might be useful to know if sensor updates will be received

// TODO: have a call to "read all configuration" with complete handlers and sync methods to retrieve from "cache"

/**
 * Returns all the labels known to this controller.
 *
 * Given the current REST API with controller, it only returns the labels from the 1st panel
 * (but from all screens in all groups).
 */
- (NSSet *)getLabels;

@end
