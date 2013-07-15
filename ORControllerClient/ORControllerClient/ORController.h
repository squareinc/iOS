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

/**
 * Initializes the controller with the provided address.
 * Does not try to connect to the controller.
 * 
 * @param anAddress address of the controller to connect to
 *
 * @return An ORController object initialized with the provided address. If no address is given, returns nil.
 */
- (id)initWithControllerAddress:(ORControllerAddress *)anAddress;

// TODO: add complete / error handlers to below methods

/**
 * Tries to establish connection to the controller.
 */
- (void)connect;

/**
 */
- (void)disconnect;

/**
 *
 * @return
 */
- (BOOL)isConnected;


/**
 */
- (void)readControllerConfiguration;
// TODO: see how to make this work with the fact that configuration is actually split in separate panels and we only read one panel at once in the console


// How about having an FixedUIController that provides higher granularity methods to perform actions required by the project.
// This class can provide finer grained methods to make it compatible with current iOS console.
// e.g. getAllLabels would iterate currently loaded panel for all labels
// readControllerConfiguration would load the list of panels, then read the first panel in the list

// TODO: if there is caching, should be able to indicate if configuration is up to date or not, ...
// Maybe need a specific object to manage configuration -> will getLabels be on that object or is this hidden ???


/**
 * Returns all the labels known to this controller.
 * If no configuration has been read for this controller, ?????
 
 // TODO: how is caching implemented, how will this impact this method
 
 *
 * Given the current REST API with controller, it only returns the labels from the 1st panel
 * (but from all screens in all groups).
 */
- (NSSet *)getAllLabels;




@end
