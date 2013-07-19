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
 * Provides utility methods to simplify dealing with operations
 * on the Objective-C runtime.
 */
@interface ORRuntimeUtils : NSObject

/**
 * Given a protocol, returns the selectors for instance methods that are defined as part of that protocol.
 * Both required and optional methods are taken into account.
 * Methods from parent protocols are not returned.
 * Class methods are not taken into account.
 *
 * @param aProtocol the Protocol to list the methods of
 *
 * @return a collection of NSValue objects, their pointerValue are the selectors of the methods in the protocol
 */
+ (NSArray *)instanceMethodsSelectorsFromProtocol:(Protocol *)aProtocol;

@end
