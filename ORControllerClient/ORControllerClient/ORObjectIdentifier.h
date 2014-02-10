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

/**
 * Represents unique identifier assigned to object model.
 * Using this class instead of an actual "primitive" type shields the object model from the exact implementation of the identifier.
 */
@interface ORObjectIdentifier : NSObject <NSCopying>

/**
 * Initializes the identifier with an integer id.
 *
 * @param intId integer id to use as identifier
 *
 * @return An ORObjectIdentifier object initialized with the provided value.
 */
- (id)initWithIntegerId:(NSInteger)intId;

/**
 * Initializes the identifier with a integer id given as a string.
 * This methods tries to convert to string to an integer.
 * If that fails, the resulting id will be initiliazed to 0.
 *
 * @param stringId string id to use as identifier
 *
 * @return An ORObjectIdentifier object initialized with the provided value.
 */
- (id)initWithStringId:(NSString *)stringId;

/**
 * Returns a string representation of this identifier.
 *
 * @return An NSString representation of this identifier.
 */
- (NSString *)stringValue;

@end