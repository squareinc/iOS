/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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

@class ORObjectIdentifier;

/**
 * Object storing reference to a given screen (or group if no screen is specified).
 * Note that an ORScreen instance does not reference its group, as it might belong to multiple ones.
 */
@interface ORScreenOrGroupReference : NSObject <NSCopying, NSCoding>

/**
 * Identifier of the group, might not be nil.
 */
@property (copy, readonly) ORObjectIdentifier *groupIdentifier;

/**
 * Identifier of the screen, might be nil if this references a group.
 */
@property (copy, readonly) ORObjectIdentifier *screenIdentifier;

/**
 * Initializes the reference with the given group and screen.
 * If not group is provided, returns nil.
 *
 * @param aGroupIdentifier The identifier of the group, might not be nil.
 * @param aScreenIdentifier The identifier of the screen, might be nil to reference the group.
 *
 * @return An ORScreenOrGroupReference object initialized with given identifiers. If no group identifier was given, returns nil.
 */
- (id)initWithGroupIdentifier:(ORObjectIdentifier *)aGroupdIdentifier screenIdentifier:(ORObjectIdentifier *)aScreenIdentifier;

@end