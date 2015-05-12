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

#import <SenTestingKit/SenTestingKit.h>

@interface ORScreenOrGroupReferenceTest : SenTestCase

/**
 * Validates that a ScreenReference can only be instantiated when the appropriate and required parameters are provided.
 */
- (void)testCreation;

/**
 * Validates the correct implementation of the isEqual: and hash methods for ScreenReference instances.
 */
- (void)testEqualityAndHash;

/**
 * Validates the correct implementation of the isEqual: and hash methods for ScreenReference instances that only have a reference to a group.
 */
- (void)testEqualityAndHashForNilScreenReference;

/**
 * Validates that when making a copy of a ScreenReference, the copy is equal to the original.
 * This validates that ScreenReference correctly adopts the NSCopying protocol.
 */
- (void)testCopy;

/**
 * Validates that when making a copy of a ScreenReference that only has a reference to a group, the copy is equal to the original.
 * This validates that ScreenReference correctly adopts the NSCopying protocol.
 */
- (void)testCopyForNilScreenReference;

/**
 * Validates that a ScreenReference can be encoded and decoded and that the decoded instance is equal to the original.
 * This validates that ScreenReference correctly adopts the NSCoding protocol.
 */
- (void)testNSCoding;

/**
 * Validates that a ScreenReference that only has a reference to a group
 * can be encoded and decoded and that the decoded instance is equal to the original.
 * This validates that ScreenReference correctly adopts the NSCoding protocol.
 */
- (void)testNSCodingForNilScreenReference;

@end