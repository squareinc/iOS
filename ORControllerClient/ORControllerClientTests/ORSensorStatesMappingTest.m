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
    XCTAssertNotNil(mapping, @"It should be possible to create an ORSensorStatesMapping");
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"Name" value:@"Value"];
    XCTAssertNotNil(state, @"It should be possible to create an ORSensorState");
    
    XCTAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state];
    XCTAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value", @"Value for state 'Name' should be 'Value'");
}

- (void)testRegisteringTwoTimesAStateForTheSameNameOverridesFirst
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value1"];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value2"];
    
    XCTAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state1];
    XCTAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value1", @"Value for state 'Name' should be 'Value1'");
    
    [mapping addSensorState:state2];
    XCTAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value2", @"Value for state 'Name' should be 'Value2' after adding the second state");
}

- (void)testEqualityAndHash
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"];
    [mapping addSensorState:state1];
    
    XCTAssertTrue([mapping isEqual:mapping], @"Mapping should be equal to itself");
    XCTAssertFalse([mapping isEqual:nil], @"Mapping should not be equal to nil");
    
    ORSensorStatesMapping *equalMapping = [[ORSensorStatesMapping alloc] init];
    [equalMapping addSensorState:state1];
    XCTAssertTrue([equalMapping isEqual:mapping], @"Mappings created with same information should be equal");
    XCTAssertEqual([equalMapping hash], [mapping hash], @"Hashses of mappings created with same information should be equal");
    
    ORSensorStatesMapping *mappingWithDifferentState = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"];
    [mappingWithDifferentState addSensorState:state2];
    XCTAssertFalse([mappingWithDifferentState isEqual:mapping], @"Mappings with different state should not be equal");
    
    ORSensorStatesMapping *mappingWithNoState = [[ORSensorStatesMapping alloc] init];
    XCTAssertFalse([mappingWithNoState isEqual:mapping], @"Mappings with different number of states should not be equal");
    
    ORSensorStatesMapping *mappingWithMoreStates = [[ORSensorStatesMapping alloc] init];
    [mappingWithMoreStates addSensorState:state1];
    [mappingWithMoreStates addSensorState:state2];
    XCTAssertFalse([mappingWithMoreStates isEqual:mapping], @"Mappings with different number of states should not be equal");
}

- (void)testEqualityAndHashWithTwoStates
{
    ORSensorStatesMapping *mappingWithTwoStates = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"];
    [mappingWithTwoStates addSensorState:state1];
    [mappingWithTwoStates addSensorState:state2];

    XCTAssertTrue([mappingWithTwoStates isEqual:mappingWithTwoStates], @"Mapping should be equal to itself");
    XCTAssertFalse([mappingWithTwoStates isEqual:nil], @"Mapping should not be equal to nil");
    
    ORSensorStatesMapping *mappingWithTwoStatesInDifferentOrder = [[ORSensorStatesMapping alloc] init];
    [mappingWithTwoStatesInDifferentOrder addSensorState:state2];
    [mappingWithTwoStatesInDifferentOrder addSensorState:state1];
    
    XCTAssertTrue([mappingWithTwoStatesInDifferentOrder isEqual:mappingWithTwoStates], @"Mappings created with same states in different order should be equal");
    XCTAssertEqual([mappingWithTwoStatesInDifferentOrder hash], [mappingWithTwoStates hash], @"Hashses of mappings created with same states in different order should be equal");
}

- (void)testStateValues
{
    ORSensorStatesMapping *mappingWithTwoStates = [[ORSensorStatesMapping alloc] init];
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"]];
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"]];
    
    XCTAssertEqualObjects([mappingWithTwoStates stateValues], ([NSSet setWithObjects:@"Value1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
    
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"New value 1"]];
    XCTAssertEqualObjects([mappingWithTwoStates stateValues], ([NSSet setWithObjects:@"New value 1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
}

- (void)testStateValuesDuplicateValues
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"]];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"]];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name3" value:@"Value1"]];
    
    XCTAssertEqualObjects([mapping stateValues], ([NSSet setWithObjects:@"Value1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
}

@end