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

#import <SenTestingKit/SenTestingKit.h>

@interface ORDeferredBindingTest : SenTestCase

/**
 * Validates that an ORDeferredBinding instance can be instantiated when giving non nil parameters
 * and that those parameters are correctly set as the object's properties.
 */
- (void)testCreateValidBinding;

/**
 * Validates that an ORDeferredBinding is not instantiated when any of the parameters is nil.
 */
- (void)testFailCreateBindingWithNilParameters;

/**
 * Validates that the bind method is not implemented on the abstract ORDeferredBinding class.
 */
- (void)testBindIsAbstract;

@end