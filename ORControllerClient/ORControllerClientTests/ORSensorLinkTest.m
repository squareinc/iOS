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
#import "ORLabel.h"

@implementation ORSensorLinkTest

- (void)testCreation
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text"];
    STAssertNotNil(link, @"Link with component and property name should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:@"text"];
    STAssertNotNil(link, @"Link with nil component and property name should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:label propertyName:nil];
    STAssertNotNil(link, @"Link with component and nil property name should be instiantiated");
    link = [[ORSensorLink alloc] initWithComponent:nil propertyName:nil];
    STAssertNotNil(link, @"Link with nil component and nil property name should be instiantiated");
}

- (void)testValuesStoredCorrectly
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text"];
    STAssertEquals(label, link.component, @"Link component should be label used to create link");
    STAssertEquals(@"text", link.propertyName, @"Link property name should be one used to create link");
}

- (void)testEqualityAndHash
{
    ORLabel *label = [[ORLabel alloc] init];
    ORSensorLink *link = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text"];
    
    STAssertTrue([link isEqual:link], @"Link should be equal to itself");
    STAssertFalse([link isEqual:nil], @"Link should not be equal to nil");
    
    ORSensorLink *equalLink = [[ORSensorLink alloc] initWithComponent:label propertyName:@"text"];
    STAssertTrue([equalLink isEqual:link], @"Links created with same information should be equal");
    STAssertEquals([equalLink hash], [link hash], @"Hashses of links created with same information should be equal");
    
    ORLabel *otherLabel = [[ORLabel alloc] init];
    ORSensorLink *linkWithDifferentComponent = [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"text"];
    STAssertFalse([linkWithDifferentComponent isEqual:link], @"Links with different component should not be equal");
    
    ORSensorLink *linkWithDifferentPropertyName = [[ORSensorLink alloc] initWithComponent:label propertyName:@"other"];
    STAssertFalse([linkWithDifferentPropertyName isEqual:link], @"Links with different property name should not be equal");
    
    ORSensorLink *linkWithDifferentComponentAndPropertyName = [[ORSensorLink alloc] initWithComponent:otherLabel propertyName:@"other"];
    STAssertFalse([linkWithDifferentComponentAndPropertyName isEqual:link], @"Links with different component and property name should not be equal");
}

@end