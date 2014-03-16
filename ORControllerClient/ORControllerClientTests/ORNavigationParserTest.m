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

#import "ORNavigationParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORNavigationParser.h"
#import "DefinitionParserMock.h"
#import "ORNavigation.h"

@implementation ORNavigationParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(setTopLevelParser:) forTag:NAVIGATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:NAVIGATE];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORNavigation *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORNavigationParser class]], @"Parser used should be an ORNavigationParser");
    ORNavigation *navigation = ((ORNavigationParser *)topLevelParser).navigation;
    STAssertNotNil(navigation, @"A slider should be parsed for given XML snippet");
    
    return navigation;
}

- (void)testParseNavigateToScreen
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate toScreen=\"12\"/>"];
    
    // TODO
    /*
    STAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], slider.identifier, @"Parsed slider should have 10 as identifer");
    
    STAssertFalse(slider.passive, @"Parsed slider should not be passive by default");
    STAssertFalse(slider.vertical, @"Parsed slider should be horizontal by default");
    
    STAssertEquals(0.0f, slider.minValue, @"Parser slider should have default minimum bound of 0");
    STAssertEquals(100.0f, slider.maxValue, @"Parser slider should have default maximum bound of 100");
    
    STAssertNil(slider.thumbImage, @"Parsed slider should not have any thumb image defined");
    STAssertNil(slider.minImage, @"Parsed slider should not have any min image defined");
    STAssertNil(slider.minTrackImage, @"Parsed slider should not have any min track image defined");
    STAssertNil(slider.maxImage, @"Parsed slider should not have any max image defined");
    STAssertNil(slider.maxTrackImage, @"Parsed slider should not have max track min image defined");
     */
}

- (void)testParseNavigateLogicalType
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate to=\"setting\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationSettings, @"Parsed navigation should navigate to settings");
    
    navigation = [self parseValidXMLSnippet:@"<navigate to=\"back\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationBack, @"Parsed navigation should navigate back");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"login\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationLogin, @"Parsed navigation should perform login");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"logout\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationLogout, @"Parsed navigation should peform logout");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"nextScreen\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationNextScreen, @"Parsed navigation should navigate to next screen");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"previousScreen\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationPreviousScreen, @"Parsed navigation should navigate to previous screen");
}

@end