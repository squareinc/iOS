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

#import "ORSensorStateParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "ORSensorStateParser.h"
#import "ORSensorState.h"
#import "DefinitionParserMock.h"

@implementation ORSensorStateParserTest

- (void)testParseValidXMLSnippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(setTopLevelParser:) forTag:@"state"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[@"<state name=\"Name\" value=\"Value\"/>" dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:@"state"];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    STAssertNotNil(parser.topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([parser.topLevelParser isMemberOfClass:[ORSensorStateParser class]], @"Parser used should be an ORSensorStateParser");
    ORSensorState *parsedState = ((ORSensorStateParser *)parser.topLevelParser).sensorState;
    STAssertEqualObjects(parsedState.name, @"Name", @"Name of parsed state should be 'Name'");
    STAssertEqualObjects(parsedState.value, @"Value", @"Value of parsed state should be 'Value'");
}

@end
