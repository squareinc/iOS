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

#import "ORObjectIdentifierTest.h"
#import "ORObjectIdentifier.h"

@implementation ORObjectIdentifierTest

- (void)testIdsWithSameIntegerIdAreEqualAndHaveSameHash
{
    ORObjectIdentifier *id1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *id2 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    
    STAssertEqualObjects(id1, id2, @"Ids with same integer id should be equal");
    STAssertTrue([id1 hash] == [id2 hash], @"Ids with same integer id should have same hash");
}

- (void)testIdsWithDifferentIntegerIdsAreNotEqual
{
    ORObjectIdentifier *id1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *id2 = [[ORObjectIdentifier alloc] initWithIntegerId:2];

    STAssertFalse([id1 isEqual:id2], @"Ids with different integer id should not be equal");
}

- (void)testIntegerAndStringInitEquivalentForSameInput
{
    ORObjectIdentifier *id1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *id2 = [[ORObjectIdentifier alloc] initWithStringId:@"1"];
    
    STAssertEqualObjects(id1, id2, @"Ids with same id should be equal");
    STAssertTrue([id1 hash] == [id2 hash], @"Ids with same id should have same hash");
}

- (void)testInvalidStringIdReturnsZeroId
{
    ORObjectIdentifier *zeroId = [[ORObjectIdentifier alloc] initWithStringId:@"invalid"];
    STAssertEqualObjects(zeroId, [[ORObjectIdentifier alloc] initWithIntegerId:0], @"Id initiliazed with invalid string should be 0");
}

- (void)testStringValue
{
    ORObjectIdentifier *identifier = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    STAssertEqualObjects([identifier stringValue], @"1", @"String representation of identifier should be '1'");
}

- (void)testCopy
{
    ORObjectIdentifier *id1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *id2 = [id1 copy];
    STAssertNotNil(id2, @"Copy should create a valid instance");
    STAssertEqualObjects(id2, id1, @"Copy should be equal to original");
    STAssertFalse(id1 == id2, @"Copy should not be same instance as original");
}

@end