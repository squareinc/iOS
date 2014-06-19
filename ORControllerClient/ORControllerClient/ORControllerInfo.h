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

@class ORControllerAddress;

/**
 * Represents basic information about a controller, including a strong identifier (supposed to be unique for each controller).
 *
 * The identifier is not mutable as controller are not supposed to change identifier.
 */
@interface ORControllerInfo : NSObject

/**
 * Initializes the controller information with the provided identifier.
 *
 * @param anIdentifier identifier of the controller
 *
 * @return An ORControllerInfo object initialized with given identifier. If no identifier was given, returns nil.
 */
- (instancetype)initWithIdentifier:(NSString *)anIdentifier;

/**
 * Identifier of the controller, unique and immutable for the lifetime of a single controller.
 */
@property (nonatomic, strong, readonly) NSString *identifier;

/**
 * Address where the controller can be contacted.
 */
@property (nonatomic, strong) ORControllerAddress *address;

/**
 * User friendly name of the controller, suitable for display to an end-user.
 */
@property (nonatomic, strong) NSString *name;

@end
