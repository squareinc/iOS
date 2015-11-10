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

#import "ORAbsoluteLayoutContainerParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORAbsoluteLayoutContainerParser.h"
#import "ORAbsoluteLayoutContainer.h"
#import "ORLabelParser.h"
#import "ORLabel.h"
#import "ORObjectIdentifier.h"

@implementation ORAbsoluteLayoutContainerParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORAbsoluteLayoutContainerParser class] endSelector:@selector(setTopLevelParser:) forTag:ABSOLUTE];
    [depRegistry registerParserClass:[ORLabelParser class] endSelector:@selector(endLabelElement:) forTag:LABEL];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:ABSOLUTE];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORAbsoluteLayoutContainer *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORAbsoluteLayoutContainerParser class]], @"Parser used should be an ORAbsoluteLayoutContainerParser");
    ORAbsoluteLayoutContainer *layoutContainer = ((ORAbsoluteLayoutContainerParser *)topLevelParser).layoutContainer;
    XCTAssertNotNil(layoutContainer, @"An absolute layout container should be parsed for given XML snippet");
    
    return layoutContainer;
}

- (void)testParseAbsoluteNoWidget
{
    ORAbsoluteLayoutContainer *layoutContainer = [self parseValidXMLSnippet:@"<absolute left=\"10\" top=\"20\" width=\"30\" height=\"40\"/>"];
    
    XCTAssertEqual(layoutContainer.left, (NSInteger)10, @"Parsed absolute layout container should have 10 as left position");
    XCTAssertEqual(layoutContainer.top, (NSInteger)20, @"Parsed absolute layout container should have 20 as top position");
    XCTAssertEqual(layoutContainer.width, (NSUInteger)30, @"Parsed absolute layout container should have 30 as width");
    XCTAssertEqual(layoutContainer.height, (NSUInteger)40, @"Parsed absolute layout container should have 40 as height");

    XCTAssertNil(layoutContainer.widget, @"Parsed absolute layout container should not contain any widget");
    XCTAssertEqual([layoutContainer.widgets count], (NSUInteger)0, @"Parsed absolute layout container should not contain any widget");
}

- (void)testParseAbsoluteIncludeLabel
{
    ORAbsoluteLayoutContainer *layoutContainer = [self parseValidXMLSnippet:@"<absolute left=\"-10\" top=\"-20\" width=\"30\" height=\"40\"><label id=\"1\" text=\"label\"/></absolute>"];
    
    XCTAssertEqual(layoutContainer.left, (NSInteger)-10, @"Parsed absolute layout container should have -10 as left position");
    XCTAssertEqual(layoutContainer.top, (NSInteger)-20, @"Parsed absolute layout container should have -20 as top position");
    XCTAssertEqual(layoutContainer.width,(NSUInteger)30,  @"Parsed absolute layout container should have 30 as width");
    XCTAssertEqual(layoutContainer.height, (NSUInteger)40, @"Parsed absolute layout container should have 40 as height");
    
    XCTAssertNotNil(layoutContainer.widget, @"Parsed absolute layout container should contain a widget");
    ORLabel *label = (ORLabel *)layoutContainer.widget;
    XCTAssertNotNil(label.identifier, @"Included label should have an identifier");
    XCTAssertEqualObjects(label.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:1], @"Included label should have 1 as identifer");
    
    XCTAssertEqual([layoutContainer.widgets count], (NSUInteger)1, @"Parsed absolute layout container should contain a widget");
    XCTAssertEqualObjects([layoutContainer.widgets anyObject], label, @"Parsed absolute widgets collection should contain parsed label");
}

@end