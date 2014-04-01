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
#import "ORObjectIdentifier.h"

@implementation ORPanelsParserTest

- (void)testValidResponseParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"RequestPanelIdentityListValidResponse" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    STAssertNil(parser.parseError, @"There should be no parsing error for valid XML");
    [self assertValidResponse:panels];
}

- (void)testInvalidXMLParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidXML" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    STAssertNil(panels, @"Invalid XML should not return any panels");
    STAssertNotNil(parser.parseError, @"A parsing error should be reported for invalid XML");
    STAssertEqualObjects([parser.parseError domain], NSXMLParserErrorDomain, @"Underlying XML parser error is propagated for malformed XML");
}

/*
 
 TODO: Ideal solution would be to validate XML structure based on schema to ensure it's what is expected for this call
 Schema validation is not that easy to perform on iOS and/or might be costly
 Best solution would be to generate ObjC classes that "compile" the schema into fast validation (along with parsing if possible)
 Haven't found tool (with appropriate license to do that)

- (void)testParsingValidXMLOtherThanExpectedOne
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"SensorValuesValidResponse_2_0_0" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    
    STAssertNil(panels, @"Unexpected XML should not return any panels");
    STAssertNotNil(parser.parseError, @"A parsing error should be reported for unexpected XML");
    
    STAssertEqualObjects(kORClientErrorDomain, [parser.parseError domain], @"OR specific errors belong to OR specific domain");

    STAssertEqual(1, [parser.parseError code], @"TODO");
}

 // TODO : also test panels response with missing element e.g. name

*/

- (void)assertValidResponse:(id)panels
{
    STAssertNotNil(panels, @"Should provide list of panels when passed in valid data");
    STAssertTrue([panels isKindOfClass:[NSArray class]], @"Parsing result should be an NSArray");
    STAssertEquals([panels count], (NSUInteger)3, @"Fixture declares 3 panels");
    for (ORPanel *panel in panels) {
        STAssertTrue([panel isKindOfClass:[ORPanel class]], @"Elements of the returned array should be ORPanel objects");
    }
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:0]).name,
                         @"Dad's iPhone",
                         @"Name of first panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:0]).identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:1],
                         @"Id of first panel should be equal to the one defined in the fixture");
    
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:1]).name,
                         @"Mom's iPad",
                         @"Name of second panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:1]).identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:141],
                         @"Id of second panel should be equal to the one defined in the fixture");
    
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:2]).name,
                         @"My iPod touch",
                         @"Name of third panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:2]).identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:263],
                         @"Id of third panel should be equal to the one defined in the fixture");
}

@end
