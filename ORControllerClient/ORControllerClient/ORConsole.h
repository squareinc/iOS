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

// TODO: update to new model object when ready
@class Navigate;

/**
 * An ORConsole represents the client application (most probably GUI) that connects to an ORController.
 *
 * This protocol defines the way the client library can communicate back to the application using it.
 * This is required when either the object model mandates a local action (e.g. navigation)
 * or when the controller wants to trigger changes in its client.
 *
 * Client applications should implement a class that adopts this protocols and provide it to the client library.
 *
 * In this first version, the client application should inject itself into the Definition either when returned to the controller,
 * either before attching itself to the controller.
 *
 // TODO: review, come up with better solution and finalize decision.
 // Maybe updating the connect... call to a connectConsole:... -> study impact
 */
@protocol ORConsole <NSObject>

/**
 * Navigate within the UI as instructed by the given Navigate object.
 *
 * @param navigation Navigate object indicating the navigation to be performed.
 */
- (void)navigate:(Navigate *)navigation;

@end
