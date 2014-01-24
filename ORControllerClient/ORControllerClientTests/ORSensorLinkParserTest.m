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

#import "ORSensorLinkParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "ORSensorState.h"
#import "DefinitionParserMock.h"
#import "ORSensor.h"
#import "ORObjectIdentifier.h"
#import "ORSensorStatesMapping.h"

@implementation ORSensorLinkParserTest

- (void)testParseValidXMLSnippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(setTopLevelParser:) forTag:@"link"];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:@"state"];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[@"<link type=\"sensor\" ref=\"12\"><state name=\"Name1\" value=\"Value1\"/><state name=\"Name2\" value=\"Value2\"/></link>" dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:@"link"];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    STAssertNotNil(parser.topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([parser.topLevelParser isMemberOfClass:[ORSensorLinkParser class]], @"Parser used should be an ORSensorLinkParser");
    ORSensorLinkParser *sensorLinkParser = (ORSensorLinkParser *)parser.topLevelParser;
    STAssertNotNil(sensorLinkParser.sensor, @"A sensor should be parsed for given XML snippet");
    STAssertEqualObjects(sensorLinkParser.sensor.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:12], @"Sensor with id 12 should have been parsed");
    STAssertNotNil(sensorLinkParser.sensorStatesMapping, @"A sensor states mapping should be parsed for given XML snipper");
    STAssertEqualObjects([sensorLinkParser.sensorStatesMapping stateValueForName:@"Name1"], @"Value1", @"Name1/Value2 state should have been parsed");
    STAssertEqualObjects([sensorLinkParser.sensorStatesMapping stateValueForName:@"Name2"], @"Value2", @"Name2/Value2 state should have been parsed");
}

@end