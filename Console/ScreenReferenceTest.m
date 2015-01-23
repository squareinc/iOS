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
#import "ScreenReference.h"
#import "ORObjectIdentifier.h"

@interface ScreenReferenceTest : SenTestCase

@end

@implementation ScreenReferenceTest

- (void)testCreation
{
    ORObjectIdentifier *groupId = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *screenId = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    
    ScreenReference *reference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:screenId];
    STAssertNotNil(reference, @"A screen reference with a group and a screen identifier should be instantiated");
    STAssertEqualObjects(reference.groupIdentifier, groupId, @"Reference's group identifier should be the one used to initialize reference");
    STAssertEqualObjects(reference.screenIdentifier, screenId, @"Reference's screen identifier should be the one used to initialize reference");
    
    reference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:nil];
    STAssertNotNil(reference, @"A screen reference with a group identifier and no screen identifier should be instantiated");
    STAssertEqualObjects(reference.groupIdentifier, groupId, @"Reference's group identifier should be the one used to initialize reference");
    STAssertNil(reference.screenIdentifier, @"Reference's screen identifier should be nil");
    
    reference = [[ScreenReference alloc] initWithGroupIdentifier:nil screenIdentifier:nil];
    STAssertNil(reference, @"A screen reference with no group and screen identifier is not allowed");
    
    reference = [[ScreenReference alloc] initWithGroupIdentifier:nil screenIdentifier:screenId];
    STAssertNil(reference, @"A screen reference with no group identifier is not allowed");
}

- (void)testEqualityAndHash
{
    ORObjectIdentifier *groupId = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *screenId = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    
    ScreenReference *reference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:screenId];

    STAssertTrue([reference isEqual:reference], @"Reference should be equal to itself");
    STAssertFalse([reference isEqual:nil], @"Reference should not be equal to nil");

    ScreenReference *equalReference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:screenId];;
    STAssertTrue([equalReference isEqual:reference], @"References created with same information should be equal");
    STAssertEquals([equalReference hash], [reference hash], @"Hashses of references created with same information should be equal");
    
    ScreenReference *referenceWithOtherGroupIdentifier = [[ScreenReference alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3] screenIdentifier:screenId];
    STAssertFalse([referenceWithOtherGroupIdentifier isEqual:reference], @"References with different group identifier should not be equal");
    
    ScreenReference *referenceWithOtherScreenIdentifier = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3]];
    STAssertFalse([referenceWithOtherScreenIdentifier isEqual:reference], @"References with different screen identifier should not be equal");
}

- (void)testEqualityAndHashForNilScreenReference
{
    ORObjectIdentifier *groupId = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    
    ScreenReference *reference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:nil];
    
    STAssertTrue([reference isEqual:reference], @"Reference should be equal to itself");
    STAssertFalse([reference isEqual:nil], @"Reference should not be equal to nil");
    
    ScreenReference *equalReference = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:nil];;
    STAssertTrue([equalReference isEqual:reference], @"References created with same information should be equal");
    STAssertEquals([equalReference hash], [reference hash], @"Hashses of references created with same information should be equal");
    
    ScreenReference *referenceWithOtherGroupIdentifier = [[ScreenReference alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3] screenIdentifier:nil];
    STAssertFalse([referenceWithOtherGroupIdentifier isEqual:reference], @"References with different group identifier should not be equal");
    
    ScreenReference *referenceWithOtherScreenIdentifier = [[ScreenReference alloc] initWithGroupIdentifier:groupId screenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3]];
    STAssertFalse([referenceWithOtherScreenIdentifier isEqual:reference], @"References with different screen identifier should not be equal");
}

- (void)testCopy
{
    ORObjectIdentifier *groupId1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *screenId1 = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    ScreenReference *reference1 = [[ScreenReference alloc] initWithGroupIdentifier:groupId1 screenIdentifier:screenId1];

    ScreenReference *reference2 = [reference1 copy];
    
    STAssertNotNil(reference2, @"Copy should create a valid instance");
    STAssertEqualObjects(reference2, reference1, @"Copy should be equal to original");
    STAssertFalse(reference1 == reference2, @"Copy should not be same instance as original");
    STAssertEqualObjects(reference2.groupIdentifier, reference1.groupIdentifier, @"Copy group identifier should be equal to original's one");
    STAssertFalse(reference1.groupIdentifier == reference2.groupIdentifier, @"Copy group identifier should be same instance as original's one");
    STAssertEqualObjects(reference2.screenIdentifier, reference1.screenIdentifier, @"Copy screen identifier should be equal to original's one");
    STAssertFalse(reference1.screenIdentifier == reference2.screenIdentifier, @"Copy screen identifier should be same instance as original's one");
}

- (void)testCopyForNilScreenReference
{
    ORObjectIdentifier *groupId1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ScreenReference *reference1 = [[ScreenReference alloc] initWithGroupIdentifier:groupId1 screenIdentifier:nil];
    
    ScreenReference *reference2 = [reference1 copy];
    
    STAssertNotNil(reference2, @"Copy should create a valid instance");
    STAssertEqualObjects(reference2, reference1, @"Copy should be equal to original");
    STAssertFalse(reference1 == reference2, @"Copy should not be same instance as original");
    STAssertEqualObjects(reference2.groupIdentifier, reference1.groupIdentifier, @"Copy group identifier should be equal to original's one");
    STAssertFalse(reference1.groupIdentifier == reference2.groupIdentifier, @"Copy group identifier should be same instance as original's one");
    STAssertNil(reference2.screenIdentifier, @"Screen identifier of copy should also be nil");
}

- (void)testNSCoding
{
    ORObjectIdentifier *groupId1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *screenId1 = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    ScreenReference *reference1 = [[ScreenReference alloc] initWithGroupIdentifier:groupId1 screenIdentifier:screenId1];
    
    NSData *encodedReference = [NSKeyedArchiver archivedDataWithRootObject:reference1];
    STAssertNotNil(encodedReference, @"Archived data should not be nil");
    ORObjectIdentifier *decodedReference = [NSKeyedUnarchiver unarchiveObjectWithData:encodedReference];
    STAssertNotNil(decodedReference, @"Decoded object should not be nil");
    STAssertEqualObjects(decodedReference, reference1, @"Decoded reference should be equal to original one");
}

- (void)testNSCodingForNilScreenReference
{
    ORObjectIdentifier *groupId1 = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ScreenReference *reference1 = [[ScreenReference alloc] initWithGroupIdentifier:groupId1 screenIdentifier:nil];
    
    NSData *encodedReference = [NSKeyedArchiver archivedDataWithRootObject:reference1];
    STAssertNotNil(encodedReference, @"Archived data should not be nil");
    ORObjectIdentifier *decodedReference = [NSKeyedUnarchiver unarchiveObjectWithData:encodedReference];
    STAssertNotNil(decodedReference, @"Decoded object should not be nil");
    STAssertEqualObjects(decodedReference, reference1, @"Decoded reference should be equal to original one");
}

@end
