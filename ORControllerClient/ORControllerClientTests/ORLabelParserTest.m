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

#import "ORLabelParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORLabelParser.h"
#import "ORLabel.h"
#import "DefinitionParserMock.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "ORObjectIdentifier.h"

@implementation ORLabelParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORLabelParser class] endSelector:@selector(setTopLevelParser:) forTag:LABEL];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:LABEL];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORLabel *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORLabelParser class]], @"Parser used should be an ORLabelParser");
    ORLabel *label = ((ORLabelParser *)topLevelParser).label;
    STAssertNotNil(label, @"A label should be parsed for given XML snippet");
    
    return label;
}

- (void)testParseLabelOnlyMandatoryAttributes
{
    ORLabel *label = [self parseValidXMLSnippet:@"<label id=\"10\" text=\"A label\"/>"];
    
    STAssertNotNil(label.identifier, @"Parsed switch should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], label.identifier, @"Parsed label should have 10 as identifer");
    STAssertEqualObjects(@"A label", label.text, @"Parsed label text should be 'A label'");
    
    STAssertEqualObjects([UIColor whiteColor], label.textColor, @"Default text color is white");
    STAssertEqualObjects([UIFont fontWithName:@"Arial" size:14.0], label.font, @"Default font is Arial 14pt");
}

- (void)testParseLabelAllAttributes
{
    ORLabel *label = [self parseValidXMLSnippet:@"<label id=\"10\" text=\"A label\" color=\"#ff0000\" fontSize=\"10\"/>"];
    
    STAssertNotNil(label.identifier, @"Parsed switch should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], label.identifier, @"Parsed label should have 10 as identifer");
    STAssertEqualObjects(@"A label", label.text, @"Parsed label text should be 'A label'");
    
    STAssertEqualObjects([UIColor redColor], label.textColor, @"Parsed label color should be red");
    STAssertEqualObjects([UIFont fontWithName:@"Arial" size:10.0], label.font, @"Parsed label should have default font (Arial) in 10pt size");
}

- (void)testParseLabelAllAttributesWithSensor
{
    ORLabel *label = [self parseValidXMLSnippet:@"<label id=\"10\" text=\"A label\" color=\"#ff0000\" fontSize=\"10\"><link type=\"sensor\" ref=\"1\"/></label>"];
    
    STAssertNotNil(label.identifier, @"Parsed switch should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], label.identifier, @"Parsed label should have 10 as identifer");
    STAssertEqualObjects(@"A label", label.text, @"Parsed label text should be 'A label'");
    
    STAssertEqualObjects([UIColor redColor], label.textColor, @"Parsed label color should be red");
    STAssertEqualObjects([UIFont fontWithName:@"Arial" size:10.0], label.font, @"Parsed label should have default font (Arial) in 10pt size");
}


@end