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

#import "ORTabBarItemParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORTabBarItemParser.h"
#import "ORImageParser.h"
#import "ORImage.h"
#import "ORNavigationParser.h"
#import "ORTabBarItem.h"
#import "ORNavigation.h"

@implementation ORTabBarItemParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORTabBarItemParser class] endSelector:@selector(setTopLevelParser:) forTag:ITEM];
    [depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(endNavigateElement:) forTag:NAVIGATE];
    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:IMAGE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:ITEM];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORTabBarItem *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORTabBarItemParser class]], @"Parser used should be an ORTabBarItemParser");
    ORTabBarItem *tabBarItem = ((ORTabBarItemParser *)topLevelParser).tabBarItem;
    STAssertNotNil(tabBarItem, @"A tab bar item should be parsed for given XML snippet");
    
    return tabBarItem;
}

- (void)testParseItemNoImageNoNavigation
{
    ORTabBarItem *item = [self parseValidXMLSnippet:@"<item name=\"item1\"/>"];
    
    STAssertNotNil(item.name, @"Parsed tab bar item should have 'item1' as name");
    STAssertNil(item.image, @"Parsed tab bar item should not have an image");
    STAssertNil(item.navigation, @"Parsed tab bar item should not have a navigation");
}

- (void)testParseItemWithImageNoNavigation
{
    ORTabBarItem *item = [self parseValidXMLSnippet:@"<item name=\"item1\"><image src=\"item.png\"/></item>"];
    
    STAssertNotNil(item.name, @"Parsed tab bar item should have 'item1' as name");
    STAssertNotNil(item.image, @"Parsed tab bar item should have an image");
    STAssertEqualObjects(item.image.name, @"item.png", @"Parsed tab bar item image should be named 'item.png'");
    STAssertNil(item.navigation, @"Parsed tab bar item should not have a navigation");
}

- (void)testParseItemNoImageWithNavigation
{
    ORTabBarItem *item = [self parseValidXMLSnippet:@"<item name=\"item1\"><navigate to=\"setting\"/></item>"];
    
    STAssertNotNil(item.name, @"Parsed tab bar item should have 'item1' as name");
    STAssertNil(item.image, @"Parsed tab bar item should not have an image");
    STAssertNotNil(item.navigation, @"Parsed tab bar item should have a navigation");
    STAssertEquals(item.navigation.navigationType, ORNavigationTypeSettings, @"Parsed tab bar item should navigate to settings");
}

- (void)testParseItemWithImageAndNavigation
{
    ORTabBarItem *item = [self parseValidXMLSnippet:@"<item name=\"item1\"><image src=\"item.png\"/><navigate to=\"back\"/></item>"];
    
    STAssertNotNil(item.name, @"Parsed tab bar item should have 'item1' as name");
    STAssertNotNil(item.image, @"Parsed tab bar item should have an image");
    STAssertEqualObjects(item.image.name, @"item.png", @"Parsed tab bar item image should be named 'item.png'");
    STAssertNotNil(item.navigation, @"Parsed tab bar item should have a navigation");
    STAssertEquals(item.navigation.navigationType, ORNavigationTypeBack, @"Parsed tab bar item should navigate back");
}

@end