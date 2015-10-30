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

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ORDataCapturingNSURLConnectionDelegate.h"

@interface ORDataCapturingNSURLConnectionDelegateTest : XCTestCase

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

- (void)testStandardNSURLConnectionDelegateMethodsAreForwarded
{
    NSURLConnection *connection = [[NSURLConnection alloc] init];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ORDataCapturingNSURLConnectionDelegateDelegate)];
    ORDataCapturingNSURLConnectionDelegate *capturingDelegate = [[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:mockDelegate];
    
    [[mockDelegate expect] connection:connection didFailWithError:[OCMArg any]];
    [capturingDelegate connection:connection didFailWithError:NULL];
    [mockDelegate verify];
    
    [[mockDelegate expect] connectionShouldUseCredentialStorage:connection];
    [capturingDelegate connectionShouldUseCredentialStorage:connection];
    [mockDelegate verify];

    [[mockDelegate expect] connection:connection willSendRequestForAuthenticationChallenge:[OCMArg any]];
    [capturingDelegate connection:connection willSendRequestForAuthenticationChallenge:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection canAuthenticateAgainstProtectionSpace:[OCMArg any]];
    [capturingDelegate connection:connection canAuthenticateAgainstProtectionSpace:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection didReceiveAuthenticationChallenge:[OCMArg any]];
    [capturingDelegate connection:connection didReceiveAuthenticationChallenge:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection didCancelAuthenticationChallenge:[OCMArg any]];
    [capturingDelegate connection:connection didCancelAuthenticationChallenge:nil];
    [mockDelegate verify];
}

- (void)testStandardNSURLConnectionDataDelegateMethodsAreForwarded
{
    NSURLConnection *connection = [[NSURLConnection alloc] init];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(ORDataCapturingNSURLConnectionDelegateDelegate)];
    ORDataCapturingNSURLConnectionDelegate *capturingDelegate = [[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:mockDelegate];
    
    [[mockDelegate expect] connection:connection willSendRequest:[OCMArg any] redirectResponse:[OCMArg any]];
    [capturingDelegate connection:connection willSendRequest:nil redirectResponse:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection didReceiveResponse:[OCMArg any]];
    [capturingDelegate connection:connection didReceiveResponse:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection needNewBodyStream:[OCMArg any]];
    [capturingDelegate connection:connection needNewBodyStream:nil];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection didSendBodyData:1 totalBytesWritten:2 totalBytesExpectedToWrite:3];
    [capturingDelegate connection:connection didSendBodyData:1 totalBytesWritten:2 totalBytesExpectedToWrite:3];
    [mockDelegate verify];
    
    [[mockDelegate expect] connection:connection willCacheResponse:[OCMArg any]];
    [capturingDelegate connection:connection willCacheResponse:nil];
    [mockDelegate verify];
}

@end