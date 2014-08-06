//
//  ScreenReferenceTest.m
//  openremote
//
//  Created by Eric Bariaux on 06/08/14.
//  Copyright (c) 2014 OpenRemote, Inc. All rights reserved.
//

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

@end
