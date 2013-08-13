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
#import "ORSensorRegistry.h"
#import "ORLabel.h"
#import "Sensor.h"
#import "SensorState.h"

@interface ORSensorPollingManager ()

- (void)updateComponentsWithSensorValues:(NSDictionary *)sensorValues;

@end

@implementation ORSensorPollingManagerTests

- (void)testUpdateComponentsWithSensorValues
{
    Sensor *sensor = [[Sensor alloc] initWithId:1];
    ORLabel *label = [[ORLabel alloc] initWithText:@"Initial text"];
    ORSensorRegistry *registry = [[ORSensorRegistry alloc] init];
    [registry registerSensor:sensor linkedToComponent:label property:@"text"];
    ORSensorPollingManager *pollingManager = [[ORSensorPollingManager alloc] initWithControllerAddress:nil sensorRegistry:registry];
    
    STAssertEqualObjects(@"Initial text", label.text, @"Label text should be its initial value before any sensor update has been done");
 
    [pollingManager updateComponentsWithSensorValues:@{@"2" : @"Some sensor value"}];
    STAssertEqualObjects(@"Initial text", label.text, @"Label text should be its initial value after update for other sensor");

    [pollingManager updateComponentsWithSensorValues:@{@"1" : @"New sensor value"}];    
    STAssertEqualObjects(@"New sensor value", label.text, @"Label text should be updated with sensor value");
    
    [sensor.states addObject:[[SensorState alloc] initWithName:@"on" value:@"On Value"]];
    
    [pollingManager updateComponentsWithSensorValues:@{@"1" : @"off"}];
    STAssertEqualObjects(@"off", label.text, @"Label text should be sensor value when no sensor state matches sensor value");

    [pollingManager updateComponentsWithSensorValues:@{@"1" : @"on"}];
    STAssertEqualObjects(@"On Value", label.text, @"Label text should be state value when sensor state matches sensor value");
}

@end
