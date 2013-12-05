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

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "ORDataCapturingNSURLConnectionDelegate.h"

@interface ORDataCapturingNSURLConnectionDelegateTest : SenTestCase

@end

@implementation ORDataCapturingNSURLConnectionDelegateTest

- (void)testReceivedDataIsCaptured
{
    NSURLConnection *connection = [[NSURLConnection alloc] init];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ORDataCapturingNSURLConnectionDelegateDelegate)];
    [[mockDelegate expect] connectionDidFinishLoading:connection receivedData:[@"ABCDEF" dataUsingEncoding:NSUTF8StringEncoding]];
    
    ORDataCapturingNSURLConnectionDelegate *capturingDelegate = [[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:mockDelegate];
    
    [capturingDelegate connection:connection didReceiveData:[@"ABC" dataUsingEncoding:NSUTF8StringEncoding]];
    [capturingDelegate connection:connection didReceiveData:[@"DEF" dataUsingEncoding:NSUTF8StringEncoding]];
    [capturingDelegate connectionDidFinishLoading:connection];
    
    [mockDelegate verify];
}

@end