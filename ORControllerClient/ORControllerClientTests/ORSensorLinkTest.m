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

#import "ORSensorLinkTest.h"
#import "ORSensorLink.h"
#import "ORSensorState.h"
#import "ORSensorStatesMapping.h"
#import "ORLabel.h"

@implementation ORSensorLinkTest

- (void)testCreation
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping];
    STAssertNotNil(link, @"Link with component, property name and mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:nil];
    STAssertNotNil(link, @"Link with component, property name and nil mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:@"text" sensorStatesMapping:mapping];
    STAssertNotNil(link, @"Link with nil component, property name and mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:@"text" sensorStatesMapping:nil];
    STAssertNotNil(link, @"Link with nil component, property name and nil mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:label propertyName:nil sensorStatesMapping:mapping];
    STAssertNotNil(link, @"Link with component, nil property name and mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:label propertyName:nil sensorStatesMapping:nil];
    STAssertNotNil(link, @"Link with component, nil property name and nil mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:nil sensorStatesMapping:mapping];
    STAssertNotNil(link, @"Link with nil component, nil property name and mapping should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:nil sensorStatesMapping:nil];
    STAssertNotNil(link, @"Link with nil component, nil property name and nil mapping should be instiantiated");
}

- (void)testValuesStoredCorrectly
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping];
    STAssertEquals(label, link.component, @"Link component should be label used to create link");
    STAssertEquals(@"text", link.propertyName, @"Link property name should be one used to create link");
    STAssertEqualObjects(mapping, link.sensorStatesMapping, @"Link sensorStatesMapping should be mapping used to create link");
}

- (void)testEqualityAndHash
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping];
    
    STAssertTrue([link isEqual:link], @"Link should be equal to itself");
    STAssertFalse([link isEqual:nil], @"Link should not be equal to nil");
    
    ORSensorLink *equalLink = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping];
    STAssertTrue([equalLink isEqual:link], @"Links created with same information should be equal");
    STAssertEquals([equalLink hash], [link hash], @"Hashses of links created with same information should be equal");
    
    ORLabel *otherLabel = [[ORLabel alloc] init];
    ORSensorLink *linkWithDifferentComponent = [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text" sensorStatesMapping:mapping];
    STAssertFalse([linkWithDifferentComponent isEqual:link], @"Links with different component should not be equal");
    
    ORSensorLink *linkWithDifferentPropertyName = [[ORSensorLink alloc] initWithComponent:label propertyName:@"other" sensorStatesMapping:mapping];
    STAssertFalse([linkWithDifferentPropertyName isEqual:link], @"Links with different property name should not be equal");

    ORSensorStatesMapping *otherMapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"off" value:@"Off value"]];

    ORSensorLink *linkWithDifferentMapping = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:otherMapping];
    STAssertFalse([linkWithDifferentMapping isEqual:link], @"Links with different mapping should not be equal");

    ORSensorLink *linkWithDifferentComponentAndPropertyName = [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other" sensorStatesMapping:mapping];
    STAssertFalse([linkWithDifferentComponentAndPropertyName isEqual:link], @"Links with different component and property name should not be equal");
    
    ORSensorLink *linkWithEverythingDifferent = [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other" sensorStatesMapping:otherMapping];
    STAssertFalse([linkWithEverythingDifferent isEqual:link], @"Links with different component, property name and mapping should not be equal");
}

- (void)testEqualityAndHashForNilProperties
{
    ORSensorLink *linkWithEverythingNil = [[ORSensorLink alloc] initWithComponent:nil propertyName:nil sensorStatesMapping:nil];
    
    STAssertTrue([linkWithEverythingNil isEqual:linkWithEverythingNil], @"Link should be equal to itself");
    STAssertFalse([linkWithEverythingNil isEqual:nil], @"Link should not be equal to nil");

    ORLabel *label = [[ORLabel alloc] init];
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"on" value:@"On value"]];

    ORSensorLink *linkWithNilComponent = [[ORSensorLink alloc] initWithComponent:nil propertyName:@"text" sensorStatesMapping:mapping];
    STAssertTrue([linkWithNilComponent isEqual:linkWithNilComponent], @"Link should be equal to itself");
    STAssertFalse([linkWithNilComponent isEqual:nil], @"Link should not be equal to nil");
    
    ORSensorLink *linkWithAllProperties = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:mapping];
    STAssertFalse([linkWithNilComponent isEqual:linkWithAllProperties], @"Links with different component should not be equal");
    
    ORSensorLink *linkWithNilPropertyName = [[ORSensorLink alloc] initWithComponent:label propertyName:nil sensorStatesMapping:mapping];
    STAssertTrue([linkWithNilPropertyName isEqual:linkWithNilPropertyName], @"Link should be equal to itself");
    STAssertFalse([linkWithNilPropertyName isEqual:nil], @"Link should not be equal to nil");
    STAssertFalse([linkWithNilPropertyName isEqual:linkWithAllProperties], @"Links with different property name should not be equal");

    ORSensorLink *linkWithNilMapping = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text" sensorStatesMapping:nil];
    STAssertTrue([linkWithNilMapping isEqual:linkWithNilMapping], @"Link should be equal to itself");
    STAssertFalse([linkWithNilMapping isEqual:nil], @"Link should not be equal to nil");
    STAssertFalse([linkWithNilMapping isEqual:linkWithAllProperties], @"Links with different mapping should not be equal");
}

@end