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

#import <XCTest/XCTest.h>

@interface ORImageLabelDeferredBindingTest : XCTestCase

/**
 * Validates that an ORImageLabelDeferredBinding instance can be instantiated when giving a non nil identifier
 * and an ORImage instance as enclosing object; and that those parameters are correctly set as the object's properties.
 */
- (void)testCreateValidBinding;

/**
 * Validates that an ORDeferredBinding is not instantiated when the enclosing object is not an ORImage instance.
 */
- (void)testFailCreateBindingWithIncorrectEnclosingObjectClass;

/**
 * Validates that when a binding is executed (bind method called), the label is correctly set on the image. 
 */
- (void)testBindingIsEstablished;

@end