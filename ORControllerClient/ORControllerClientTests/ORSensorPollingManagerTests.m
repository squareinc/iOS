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

#import "ORSensorPollingManagerTests.h"
#import "ORSensorPollingManager.h"
#import "ORPanelDefinitionSensorRegistry.h"
#import "ORObjectIdentifier.h"
#import "ORLabel_Private.h"
#import "ORSensor.h"
#import "ORSensorStatesMapping.h"
#import "ORSensorState.h"
#import "ControllerREST_2_0_0_API.h"
#import "ORControllerRESTAPI_ScriptableMock.h"

@interface ORSensorPollingManager ()

- (void)updateComponentsWithSensorValues:(NSDictionary *)sensorValues;

@end

@implementation ORSensorPollingManagerTests

- (void)testAppropriateAPIMethodsCalledOnStart
{
    ORControllerRESTAPI_ScriptableMock *api = [[ORControllerRESTAPI_ScriptableMock alloc] init];
    api.sensorStatusResult = @{@"1": @"on"};
    api.sensorPollResult = @{@"1": @"on"};
    api.sensorPollMaxCall = 3;
    
    ORSensor *sensor = [[ORSensor alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1]];
    ORLabel *label = [[ORLabel alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2] text:@"Initial text"];
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    [registry registerSensor:sensor linkedToComponent:label property:@"text" sensorStatesMapping:nil];
    ORSensorPollingManager *pollingManager = [[ORSensorPollingManager alloc] initWithControllerAPI:api controllerAddress:nil];
    [pollingManager addSensorRegistry:registry];
    
    [pollingManager start];
    
    XCTAssertEqual(api.sensorStatusCallCount, (NSUInteger)1, @"Status request should have been called once");
    XCTAssertEqual(api.sensorPollCallCount, (NSUInteger)3, @"Poll request should have been called once");
}

- (void)testNoAPICallWhenNoRegisteredSensors
{
    ORControllerRESTAPI_ScriptableMock *api = [[ORControllerRESTAPI_ScriptableMock alloc] init];
    api.sensorStatusResult = @{@"1": @"on"};
    api.sensorPollResult = @{@"1": @"on"};
    api.sensorPollMaxCall = 3;
    
    ORPanelDefinitionSensorRegistry *registry = [[ORPanelDefinitionSensorRegistry alloc] init];
    ORSensorPollingManager *pollingManager = [[ORSensorPollingManager alloc] initWithControllerAPI:api controllerAddress:nil];
    [pollingManager addSensorRegistry:registry];

    [pollingManager start];
    
    XCTAssertEqual(api.sensorStatusCallCount, (NSUInteger)0, @"Status request should not have been called when no sensor registered");
    XCTAssertEqual(api.sensorPollCallCount, (NSUInteger)0, @"Poll request should not have been called when no sensor registered");
}

@end
