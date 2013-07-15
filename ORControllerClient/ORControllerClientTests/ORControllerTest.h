//
//  ORControllerTest.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

/**
 * Unit tests for ORController
 */
@interface ORControllerTest : SenTestCase

/**
 * Initiliazes the ORController with a valid address.
 * Validates that an ORController instance is returned.
 * Validates that it is not connected.
 */
- (void)testCreateWithValidAddress;

/**
 * Initiliazes the ORController with nil as the address parameter.
 * Validates that an ORController is not created in this case.
 */
- (void)testCreateWithNilAddress;

@end
