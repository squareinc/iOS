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

#import "ORGridLayoutContainerParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORGridLayoutContainerParser.h"
#import "ORGridLayoutContainer.h"
#import "ORGridCellParser.h"
#import "ORGridCell.h"

@implementation ORGridLayoutContainerParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORGridLayoutContainerParser class] endSelector:@selector(setTopLevelParser:) forTag:GRID];
    [depRegistry registerParserClass:[ORGridCellParser class] endSelector:@selector(endCellElement:) forTag:@"cell"];

    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:GRID];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORGridLayoutContainer *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORGridLayoutContainerParser class]], @"Parser used should be an ORGridLayoutContainerParser");
    ORGridLayoutContainer *layoutContainer = ((ORGridLayoutContainerParser *)topLevelParser).layoutContainer;
    STAssertNotNil(layoutContainer, @"A grid layout container should be parsed for given XML snippet");
    
    return layoutContainer;
}

- (void)testParseGridNoCell
{
    ORGridLayoutContainer *layoutContainer = [self parseValidXMLSnippet:@"<grid left=\"10\" top=\"20\" width=\"30\" height=\"40\" rows=\"3\" cols=\"2\"/>"];
    
    STAssertEquals(10, layoutContainer.left, @"Parsed grid layout container should have 10 as left position");
    STAssertEquals(20, layoutContainer.top, @"Parsed grid layout container should have 20 as top position");
    STAssertEquals((NSUInteger)30, layoutContainer.width, @"Parsed grid layout container should have 30 as width");
    STAssertEquals((NSUInteger)40, layoutContainer.height, @"Parsed grid layout container should have 40 as height");
    STAssertEquals((NSUInteger)3, layoutContainer.rows, @"Parsed grid layout container should have 3 rows");
    STAssertEquals((NSUInteger)2, layoutContainer.cols, @"Parsed grid layout container should have 2 columns");
    
    STAssertEquals((NSUInteger)0, [layoutContainer.cells count], @"Parsed grid layout container should not contain any cell");
}

- (void)testParseAbsoluteIncludeOneCell
{
    ORGridLayoutContainer *layoutContainer = [self parseValidXMLSnippet:@"<grid left=\"10\" top=\"20\" width=\"30\" height=\"40\" rows=\"3\" cols=\"2\"><cell x=\"0\" y=\"0\"/></grid>"];
    
    STAssertEquals(10, layoutContainer.left, @"Parsed grid layout container should have 10 as left position");
    STAssertEquals(20, layoutContainer.top, @"Parsed grid layout container should have 20 as top position");
    STAssertEquals((NSUInteger)30, layoutContainer.width, @"Parsed grid layout container should have 30 as width");
    STAssertEquals((NSUInteger)40, layoutContainer.height, @"Parsed grid layout container should have 40 as height");
    STAssertEquals((NSUInteger)3, layoutContainer.rows, @"Parsed grid layout container should have 3 rows");
    STAssertEquals((NSUInteger)2, layoutContainer.cols, @"Parsed grid layout container should have 2 columns");
    
    STAssertEquals((NSUInteger)1, [layoutContainer.cells count], @"Parsed absolute layout container should contain one cell");
}

- (void)testParseAbsoluteIncludeTwoCells
{
    ORGridLayoutContainer *layoutContainer = [self parseValidXMLSnippet:@"<grid left=\"10\" top=\"20\" width=\"30\" height=\"40\" rows=\"3\" cols=\"2\"><cell x=\"0\" y=\"0\"/><cell x=\"1\" y=\"0\"/></grid>"];
    
    STAssertEquals(10, layoutContainer.left, @"Parsed grid layout container should have 10 as left position");
    STAssertEquals(20, layoutContainer.top, @"Parsed grid layout container should have 20 as top position");
    STAssertEquals((NSUInteger)30, layoutContainer.width, @"Parsed grid layout container should have 30 as width");
    STAssertEquals((NSUInteger)40, layoutContainer.height, @"Parsed grid layout container should have 40 as height");
    STAssertEquals((NSUInteger)3, layoutContainer.rows, @"Parsed grid layout container should have 3 rows");
    STAssertEquals((NSUInteger)2, layoutContainer.cols, @"Parsed grid layout container should have 2 columns");
    
    STAssertEquals((NSUInteger)2, [layoutContainer.cells count], @"Parsed absolute layout container should contain two cells");
}

@end