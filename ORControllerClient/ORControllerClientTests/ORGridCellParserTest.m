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
#import "ORGridCellParserTest.h"

#import "ORGridLayoutContainerParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORGridCellParser.h"
#import "ORGridCell.h"
#import "ORLabelParser.h"
#import "ORLabel.h"
#import "ORObjectIdentifier.h"

@implementation ORGridCellParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORGridCellParser class] endSelector:@selector(setTopLevelParser:) forTag:@"cell"];
    [depRegistry registerParserClass:[ORLabelParser class] endSelector:@selector(endLabelElement:) forTag:LABEL];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:@"cell"];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORGridCell*)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORGridCellParser class]], @"Parser used should be an ORGridCellParser");
    ORGridCell *cell = ((ORGridCellParser *)topLevelParser).cell;
    STAssertNotNil(cell, @"A grid layout container should be parsed for given XML snippet");
    
    return cell;
}

- (void)testParseGridCell
{
    ORGridCell *cell = [self parseValidXMLSnippet:@"<cell x=\"1\" y=\"2\"><label id=\"1\" text=\"label\"/></cell>"];
    
    STAssertEquals((NSUInteger)1, cell.x, @"Parsed grid cell should have 1 as x coordinate");
    STAssertEquals((NSUInteger)2, cell.y, @"Parsed grid cell should have 2 as y coordinate");
    
    STAssertNotNil(cell.widget, @"Parsed cell should contain a widget");
    ORLabel *label = (ORLabel *)cell.widget;
    STAssertNotNil(label.identifier, @"Included label should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:1], label.identifier, @"Included label should have 1 as identifer");
}

@end