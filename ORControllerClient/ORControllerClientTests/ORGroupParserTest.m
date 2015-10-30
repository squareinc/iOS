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

#import "ORGroupParserTest.h"
#import "ORGroupParser.h"
#import "ORGroup.h"
#import "ORScreenParser.h"
#import "ORScreen_Private.h"
#import "ORTabBarParser.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "DefinitionParserMock.h"

@implementation ORGroupParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    
    Definition *definition = [[Definition alloc] init];
    ORScreen *screen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:12]
                                                             name:@"Screen"
                                                      orientation:ORScreenOrientationPortrait];
    [definition addScreen:screen];
    depRegistry.definition = definition;
    
    [depRegistry registerParserClass:[ORGroupParser class] endSelector:@selector(setTopLevelParser:) forTag:GROUP];
    [depRegistry registerParserClass:[ORTabBarParser class] endSelector:@selector(endTabBarElement:) forTag:TABBAR];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:GROUP];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    // This is normally done by PanelDefinitionParser, must call it manually when testing
    [depRegistry performDeferredBindings];
    
    return parser.topLevelParser;
}

- (ORGroup *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORGroupParser class]], @"Parser used should be an ORGroupParser");
    ORGroup *group = ((ORGroupParser *)topLevelParser).group;
    XCTAssertNotNil(group, @"A group should be parsed for given XML snippet");
    
    return group;
}

- (void)testParseGroupOnlyMandatoryAttributes
{
    ORGroup *group = [self parseValidXMLSnippet:@"<group id=\"11\" name=\"Group 11\"/>"];
    
    XCTAssertNotNil(group.identifier, @"Parsed group should have an identifier");
    XCTAssertEqualObjects(group.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Parsed group should have 11 as identifer");
    XCTAssertEqualObjects(group.name, @"Group 11", @"Parsed group should be named 'Group 11'");
    
    XCTAssertNil(group.tabBar, @"Parsed group should not have a tab bar");
    XCTAssertEqual([group.screens count], (NSUInteger)0, @"Parsed group should not have any screen");
}

- (void)testParseGroupWithTabBar
{
    ORGroup *group = [self parseValidXMLSnippet:@"<group id=\"11\" name=\"Group 11\"><tabbar/></group>"];
    
    XCTAssertNotNil(group.identifier, @"Parsed group should have an identifier");
    XCTAssertEqualObjects(group.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Parsed group should have 11 as identifer");
    XCTAssertEqualObjects(group.name, @"Group 11", @"Parsed group should be named 'Group 11'");
    
    XCTAssertNotNil(group.tabBar, @"Parsed group should have a tab bar");
    XCTAssertEqual([group.screens count], (NSUInteger)0, @"Parsed group should not have any screen");
}

- (void)testParseGroupWithScreen
{
    ORGroup *group = [self parseValidXMLSnippet:@"<group id=\"11\" name=\"Group 11\"><include type=\"screen\" ref=\"12\"/></group>"];
    
    XCTAssertNotNil(group.identifier, @"Parsed group should have an identifier");
    XCTAssertEqualObjects(group.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Parsed group should have 11 as identifer");
    XCTAssertEqualObjects(group.name, @"Group 11", @"Parsed group should be named 'Group 11'");
    
    XCTAssertNil(group.tabBar, @"Parsed group should not have a tab bar");
    
    XCTAssertEqual([group.screens count], (NSUInteger)1, @"Parsed group should have a screen");
    ORScreen *screen = [group.screens lastObject];
    XCTAssertEqualObjects(screen.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:12], @"Parsed group's only screen should have 12 is identifier");
}

@end