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

#import "ORControllerClientOverallTest.h"
#import "ORControllerAddress.h"
#import "ORController.h"
#import "ORSimpleUIConfiguration.h"
#import "ORLabel.h"

#import "ORBMockURLProtocol.h"

@implementation ORControllerClientOverallTest

- (void)testLabels
{
    [NSURLProtocol registerClass:[ORBMockURLProtocol class]];
    
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"orbmock://controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    [orb connectWithSuccessHandler:^{
        STAssertTrue([orb isConnected], @"ORB should now be connected");
        [orb readSimpleUIConfigurationWithSuccessHandler:^(ORSimpleUIConfiguration *configuration) {
            NSSet *labels = [configuration labels];
            STAssertNotNil(labels, @"ORB should return a collection of labels");
            STAssertEquals([labels count], (NSUInteger)1, @"ORB should return one label in collection");
            STAssertTrue([[labels anyObject] isMemberOfClass:[ORLabel class]], @"Domain object should be an ORLabel");
            STAssertEqualObjects(((ORLabel *)[labels anyObject]).text, @"Test label 1", @"Text of label should be 'Test label 1'");
        } errorHandler:^(NSError *error) {
            STFail(@"Test failed with error %@", error);
        }];
    } errorHandler:^(NSError *error) {
        STFail(@"Test failed with error %@", error);
    }];
}

@end
