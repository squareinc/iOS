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

#import "ORImageParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORImageParser.h"
#import "ORImage.h"
#import "ORLabel_Private.h"
#import "ORLabelParser.h"
#import "DefinitionParserMock.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "ORObjectIdentifier.h"
#import "Definition.h"

@implementation ORImageParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    
    Definition *definition = [[Definition alloc] init];
    ORLabel *label = [[ORLabel alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] text:@"FBL"];
    [definition addLabel:label];
    depRegistry.definition = definition;

    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(setTopLevelParser:) forTag:IMAGE];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:IMAGE];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    // This is normally done by PanelDefinitionParser, must call it manually when testing
    [depRegistry performDeferredBindings];

    return parser.topLevelParser;
}

- (ORImage *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORImageParser class]], @"Parser used should be an ORImageParser");
    ORImage *image = ((ORImageParser *)topLevelParser).image;
    XCTAssertNotNil(image, @"A label should be parsed for given XML snippet");
    
    return image;
}

- (void)testParseImageOnlyMandatoryAttributes
{
    ORImage *image = [self parseValidXMLSnippet:@"<image id=\"10\" src=\"img.png\"/>"];
    
    XCTAssertNotNil(image.identifier, @"Parsed image should have an identifier");
    XCTAssertEqualObjects(image.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed image should have 10 as identifer");
    XCTAssertEqualObjects(image.src, @"img.png", @"Parsed image src should be 'img.png'");

    XCTAssertNil(image.label, @"Parsed image should not have a fallback label");
}

- (void)testParseImageWithFallbackLabel
{
    ORImage *image = [self parseValidXMLSnippet:@"<image id=\"10\" src=\"img.png\"><include type=\"label\" ref=\"1\"/></image>"];
    
    XCTAssertNotNil(image.identifier, @"Parsed image should have an identifier");
    XCTAssertEqualObjects(image.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed image should have 10 as identifer");
    XCTAssertEqualObjects(image.src, @"img.png", @"Parsed image src should be 'img.png'");
    
    XCTAssertNotNil(image.label, @"Parsed image should have a fallback label");
    XCTAssertEqualObjects(image.label.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:1], @"Parsed image fallback label identifier should be 1");
}

- (void)testParseImageWithFallbackLabelAndSensor
{
    ORImage *image = [self parseValidXMLSnippet:@"<image id=\"10\" src=\"img.png\"><include type=\"label\" ref=\"1\"/><link type=\"sensor\" ref=\"3\"/></image>"];
    
    XCTAssertNotNil(image.identifier, @"Parsed image should have an identifier");
    XCTAssertEqualObjects(image.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed image should have 10 as identifer");
    XCTAssertEqualObjects(image.src, @"img.png", @"Parsed image src should be 'img.png'");
    
    XCTAssertNotNil(image.label, @"Parsed image should have a fallback label");
    XCTAssertEqualObjects(image.label.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:1], @"Parsed image fallback label identifier should be 1");
}

@end