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

#import "ORSensorStateTest.h"
#import "ORSensorState.h"

@implementation ORSensorStateTest

- (void)testInitDoesSetPropertiesCorrectly
{
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"name" value:@"value"];
    STAssertNotNil(state, @"It should be possible to create an ORSensorState with a valid name and value");
    STAssertEqualObjects(state.name, @"name", @"Name should be the one set in the initializer");
    STAssertEqualObjects(state.value, @"value", @"Value should be the one set in the initializer");
}

- (void)testNilNameNotAllowed
{
    STAssertNil([[ORSensorState alloc] initWithName:nil value:@"value"], @"It is not allowed to instantiate an ORSensorState with a nil name");
}

- (void)testEqualityAndHash
{
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"name" value:@"value"];
    
    STAssertTrue([state isEqual:state], @"State should be equal to itself");
    STAssertFalse([state isEqual:nil], @"State should not be equal to nil");
    
    ORSensorState *equalState = [[ORSensorState alloc] initWithName:@"name" value:@"value"];
    STAssertTrue([equalState isEqual:state], @"States created with same information should be equal");
    STAssertEquals([equalState hash], [state hash], @"Hashses of states created with same information should be equal");

    ORSensorState *stateWithDifferentName = [[ORSensorState alloc] initWithName:@"other name" value:@"value"];
    STAssertFalse([stateWithDifferentName isEqual:state], @"States with different name should not be equal");

    ORSensorState *stateWithDifferentValue = [[ORSensorState alloc] initWithName:@"name" value:@"other value"];
    STAssertFalse([stateWithDifferentValue isEqual:state], @"States with different value should not be equal");
    
    ORSensorState *linkWithDifferentNameAndValue = [[ORSensorState alloc] initWithName:@"other name" value:@"other value"];
    STAssertFalse([linkWithDifferentNameAndValue isEqual:state], @"States with different name and value should not be equal");
}

- (void)testEqualityAndHashForNilValue
{
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"name" value:nil];

    STAssertTrue([state isEqual:state], @"State should be equal to itself");
    STAssertFalse([state isEqual:nil], @"State should not be equal to nil");

    ORSensorState *equalState = [[ORSensorState alloc] initWithName:@"name" value:nil];
    STAssertTrue([equalState isEqual:state], @"States created with same information should be equal");
    STAssertEquals([equalState hash], [state hash], @"Hashses of states created with same information should be equal");
    
    ORSensorState *stateWithDifferentName = [[ORSensorState alloc] initWithName:@"other name" value:nil];
    STAssertFalse([stateWithDifferentName isEqual:state], @"States with different name should not be equal");
    
    ORSensorState *stateWithDifferentValue = [[ORSensorState alloc] initWithName:@"name" value:@"other value"];
    STAssertFalse([stateWithDifferentValue isEqual:state], @"States with different value should not be equal");
    
    ORSensorState *linkWithDifferentNameAndValue = [[ORSensorState alloc] initWithName:@"other name" value:@"other value"];
    STAssertFalse([linkWithDifferentNameAndValue isEqual:state], @"States with different name and value should not be equal");
}

@end
