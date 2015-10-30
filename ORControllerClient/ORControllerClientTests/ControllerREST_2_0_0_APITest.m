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

#import "ControllerREST_2_0_0_APITest.h"
#import "ControllerREST_2_0_0_API_NonConnectingMock.h"
#import "ORRestCallMock.h"
#import "ORDevice_Private.h"
#import "OCMock.h"

@interface ControllerREST_2_0_0_APITest ()

@property (nonatomic, strong) ControllerREST_2_0_0_API *api;

@end

@implementation ControllerREST_2_0_0_APITest

- (void)setUp
{
    self.api = [[ControllerREST_2_0_0_API_NonConnectingMock alloc] init];
}

- (void)testRequestPanelIdentityList
{
    ORRestCallMock *call = (ORRestCallMock *)[self.api requestPanelIdentityListAtBaseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/panels", @"URL not matching expected URL as per specifications");
}

- (void)testRequestPanelLayout
{
    ORRestCallMock *call = (ORRestCallMock *)[self.api requestPanelLayoutWithLogicalName:@"A panel" atBaseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/panel/A%20panel", @"URL not matching expected URL as per specifications");
}

- (void)testStatusForSensors
{
    ORRestCallMock *call = (ORRestCallMock *)[self.api statusForSensorIds:[NSSet setWithObjects:@"1", @"2", nil] atBaseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/status/1,2", @"URL not matching expected URL as per specifications");
}

- (void)testPollSensors
{
    ORRestCallMock *call = (ORRestCallMock *)[self.api pollSensorIds:[NSSet setWithObjects:@"1", @"2", nil] fromDeviceWithIdentifier:@"DevID" atBaseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/polling/DevID/1,2", @"URL not matching expected URL as per specifications");
}

- (void)testRequestDevicesList
{
    ORRestCallMock *call = (ORRestCallMock *)[self.api requestDevicesListAtBaseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/devices", @"URL not matching expected URL as per specifications");
}

- (void)testRequestDevice
{
    id device = OCMClassMock([ORDevice class]);
    [OCMStub([device name]) andReturn:@"deviceName"];
    ORRestCallMock *call = (ORRestCallMock *)[self.api requestDevice:device baseURL:[NSURL URLWithString:@"http://localhost:8688/controller"] withSuccessHandler:NULL errorHandler:NULL];
    XCTAssertEqualObjects(call.requestURL, @"http://localhost:8688/controller/rest/devices/deviceName", @"URL not matching expected URL as per specifications");
}

@end
