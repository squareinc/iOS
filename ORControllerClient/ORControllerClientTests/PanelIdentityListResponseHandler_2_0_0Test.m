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

#import "PanelIdentityListResponseHandler_2_0_0Test.h"
#import "PanelIdentityListResponseHandler_2_0_0.h"
#import "ORPanelsParserTest.h"
#import "ORPanel.h"

@interface ORPanelsParserTest ()

- (void)assertValidResponse:(id)panels;

@end

@implementation PanelIdentityListResponseHandler_2_0_0Test

- (void)testSuccessfulResponse
{
    NSCondition *callbackDone = [[NSCondition alloc] init];
    __block BOOL successHandlerCalled = NO;
    void (^successHandler)(NSArray *) = ^(NSArray *panels) {
        [callbackDone lock];
        successHandlerCalled = YES;
        [callbackDone signal];
        [callbackDone unlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[ORPanelsParserTest alloc] init] assertValidResponse:panels];
        });
    };
    PanelIdentityListResponseHandler_2_0_0 *responseHandler = [[PanelIdentityListResponseHandler_2_0_0 alloc]
                                                               initWithSuccessHandler:successHandler
                                                               errorHandler:^(NSError *error) {
                                                                   XCTFail(@"No error should be reported");
                                                               }];
    
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"RequestPanelIdentityListValidResponse" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [responseHandler connectionDidFinishLoading:nil receivedData:data];
    
    // Success handler now called in the background, so should wait before doing the assertion
    [callbackDone lock];
    [callbackDone waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
    [callbackDone unlock];
    
    XCTAssertTrue(successHandlerCalled, @"Success handler should have been called upon receiving response with valid data");
}

@end
