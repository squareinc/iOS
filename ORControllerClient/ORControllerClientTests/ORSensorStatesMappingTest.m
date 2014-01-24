/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
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

#import "ORSensorStatesMappingTest.h"
#import "ORSensorStatesMapping.h"
#import "ORSensorState.h"

@implementation ORSensorStatesMappingTest

- (void)testSingleStateLookup
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    STAssertNotNil(mapping, @"It should be possible to create an ORSensorStatesMapping");
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"Name" value:@"Value"];
    STAssertNotNil(state, @"It should be possible to create an ORSensorState");
    
    STAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value", @"Value for state 'Name' should be 'Value'");
}

- (void)testRegisteringTwoTimesAStateForTheSameNameOverridesFirst
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value1"];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value2"];
    
    STAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state1];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value1", @"Value for state 'Name' should be 'Value1'");
    
    [mapping addSensorState:state2];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value2", @"Value for state 'Name' should be 'Value2' after adding the second state");
}

@end