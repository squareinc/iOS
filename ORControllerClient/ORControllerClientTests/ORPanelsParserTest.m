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

#import "ORPanelsParserTest.h"
#import "ORPanelsParser.h"
#import "ORPanel.h"

@implementation ORPanelsParserTest

- (void)testValidResponseParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"RequestPanelIdentityListValidResponse" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    
    STAssertNotNil(panels, @"Should provide list of panels when passed in valid data");
    STAssertTrue([panels isKindOfClass:[NSArray class]], @"Parsing result should be an NSArray");
    STAssertEquals([panels count], (NSUInteger)3, @"Fixture declares 3 panels");
    for (ORPanel *panel in panels) {
        STAssertTrue([panel isKindOfClass:[ORPanel class]], @"Elements of the returned array should be ORPanel objects");
    }
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:0]).name,
                         @"Dad's iPhone",
                         @"Name of first panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:1]).name,
                         @"Mom's iPad",
                         @"Name of second panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:2]).name,
                         @"My iPod touch",
                         @"Name of third panel should be equal to the one defined in the fixture");
}

@end
