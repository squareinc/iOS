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
#import "ORSwitchParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORSwitchParser.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "DefinitionParserMock.h"
#import "ORSwitch.h"
#import "ORImage.h"
#import "ORObjectIdentifier.h"

@implementation ORSwitchParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORSwitchParser class] endSelector:@selector(setTopLevelParser:) forTag:SWITCH];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:SWITCH];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORSwitch *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORSwitchParser class]], @"Parser used should be an ORSwitchParser");
    ORSwitch *sswitch = ((ORSwitchParser *)topLevelParser).sswitch;
    STAssertNotNil(sswitch, @"A switch should be parsed for given XML snippet");
    
    return sswitch;
}

- (void)testParseSwitchNoSensor
{
    ORSwitch *sswitch = [self parseValidXMLSnippet:@"<switch id=\"10\"/>"];

    STAssertNotNil(sswitch.identifier, @"Parsed switch should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], sswitch.identifier, @"Parsed switch should have 10 as identifer");

    STAssertNil(sswitch.onImage, @"Parsed switch should not have any on image defined");
    STAssertNil(sswitch.offImage, @"Parsed switch should not have any on image defined");
}

- (void)testParseSwitchSensorWithImages
{
    ORSwitch *sswitch = [self parseValidXMLSnippet:@"<switch id=\"10\"><link type=\"sensor\" ref=\"20\"><state name=\"on\" value=\"OnImage.png\"/><state name=\"off\" value=\"OffImage.png\"/></link></switch>"];

    STAssertNotNil(sswitch.identifier, @"Parsed switch should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], sswitch.identifier, @"Parsed switch should have 10 as identifer");

    STAssertNotNil(sswitch.onImage, @"Parsed switch should have an on image defined");
    STAssertEqualObjects(sswitch.onImage.name, @"OnImage.png", @"Parsed switch on image should be named 'OnImage.png'");

    STAssertNotNil(sswitch.offImage, @"Parsed switch should have an off image defined");
    STAssertEqualObjects(sswitch.offImage.name, @"OffImage.png", @"Parsed switch off image should be named 'OffImage.png'");
}

@end