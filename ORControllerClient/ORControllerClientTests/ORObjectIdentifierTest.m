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

@end
