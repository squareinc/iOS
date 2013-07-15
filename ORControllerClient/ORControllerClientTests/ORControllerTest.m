//
//  ORControllerTest.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORControllerTest.h"
#import "ORControllerAddress.h"
#import "ORController.h"

@implementation ORControllerTest

- (void)testCreateWithValidAddress;
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"http://localhost:8688/controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    STAssertNotNil(orb, @"Creating an ORController with a valid ORControllerAddress should be possible");
    STAssertFalse([orb isConnected], @"Newly created ORController should not be connected");
}

- (void)testCreateWithNilAddress
{
    ORController *orb = [[ORController alloc] initWithControllerAddress:nil];
    STAssertNil(orb, @"Creating an ORController with no address should not be possible");
}

@end
