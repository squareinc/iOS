//
//  ORControllerClientOverallTest.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORControllerClientOverallTest.h"
#import "ORControllerAddress.h"
#import "ORController.h"
#import "ORLabel.h"

@implementation ORControllerClientOverallTest

- (void)testLabels
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"http://localhost:8688/controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    [orb connectWithSuccessHandler:^{
        STAssertTrue([orb isConnected], @"ORB should now be connected");
        [orb readControllerConfigurationWithSuccessHandler:^{
            NSSet *labels = [orb allLabels];
            STAssertNotNil(labels, @"ORB should return a collection of labels");
        } errorHandler:NULL];
    } errorHandler:NULL];
}

@end
