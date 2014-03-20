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

#import "ORScreenParserTest.h"
#import "ORScreenParser.h"
#import "ORScreen_Private.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "DefinitionParserMock.h"
#import "ORBackgroundParser.h"
#import "ORImageParser.h"
#import "AbsoluteLayoutContainerParser.h"
#import "ORAbsoluteLayoutContainer.h"
#import "GridLayoutContainerParser.h"
#import "ORGridLayoutContainer.h"
#import "ORGestureParser.h"

@implementation ORScreenParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    
    Definition *definition = [[Definition alloc] init];
    ORScreen *screen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:12]
                                                             name:@"Screen"
                                                      orientation:ORScreenOrientationPortrait];
    [definition addScreen:screen];
    depRegistry.definition = definition;
    
    [depRegistry registerParserClass:[ORScreenParser class] endSelector:@selector(setTopLevelParser:) forTag:SCREEN];
    [depRegistry registerParserClass:[ORBackgroundParser class] endSelector:@selector(endBackgroundElement:) forTag:BACKGROUND];
    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:IMAGE];
    [depRegistry registerParserClass:[AbsoluteLayoutContainerParser class] endSelector:@selector(endLayoutElement:) forTag:ABSOLUTE];
    [depRegistry registerParserClass:[GridLayoutContainerParser class] endSelector:@selector(endLayoutElement:) forTag:GRID];
    [depRegistry registerParserClass:[ORGestureParser class] endSelector:@selector(endGestureElement:) forTag:GESTURE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:SCREEN];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    // This is normally done by PanelDefinitionParser, must call it manually when testing
    [depRegistry performDeferredBindings];
    
    return parser.topLevelParser;
}

- (ORScreen *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORScreenParser class]], @"Parser used should be an ORScreenParser");
    ORScreen *screen = ((ORScreenParser *)topLevelParser).screen;
    STAssertNotNil(screen, @"A screen should be parsed for given XML snippet");
    
    return screen;
}

- (void)testParseScreenOnlyMandatoryAttributes
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\"/>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationPortrait, screen.orientation, @"Parsed screen should be in portrait orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");
    
    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)0, [screen.layouts count], @"Parsed screen should not contain any layout");
}

- (void)testParseLandscapeScreen
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\" landscape=\"true\"/>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationLandscape, screen.orientation, @"Parsed screen should be in landscape orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");

    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)0, [screen.layouts count], @"Parsed screen should not contain any layout");
}

- (void)testParseLandscapeScreenWithLinkToOtherOrientationScreen
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\" landscape=\"true\" inverseScreenId=\"12\"/>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationLandscape, screen.orientation, @"Parsed screen should be in landscape orientation");
    STAssertNotNil(screen.rotatedScreen, @"Parsed screen should be linked to a screen for other orientation");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:12], screen.rotatedScreen.identifier,
                         @"Parsed screen should be link to screen with id 12 for other orientation");

    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)0, [screen.layouts count], @"Parsed screen should not contain any layout");
}

- (void)testParseScreenWithBackground
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\"><background image=\"bg.png\"/></screen>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationPortrait, screen.orientation, @"Parsed screen should be in portrait orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");

    STAssertNotNil(screen.background, @"Parsed screen should have a background");
    
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)0, [screen.layouts count], @"Parsed screen should not contain any layout");
}

- (void)testParseScreenWithAbsoluteLayout
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\"><absolute left=\"0\" top=\"0\" width=\"10\" height=\"10\"/></screen>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationPortrait, screen.orientation, @"Parsed screen should be in portrait orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");
    
    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)1, [screen.layouts count], @"Parsed screen should contain one layout");
    STAssertTrue([[screen.layouts lastObject] isKindOfClass:[ORAbsoluteLayoutContainer class]], @"Parsed screen should contain one absolute layout");
}

- (void)testParseScreenWithGridLayout
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\"><grid/></screen>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationPortrait, screen.orientation, @"Parsed screen should be in portrait orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");
    
    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)0, [screen.gestures count], @"Parsed screen should not have any gesture");
    STAssertEquals((NSUInteger)1, [screen.layouts count], @"Parsed screen should contain one layout");
    STAssertTrue([[screen.layouts lastObject] isKindOfClass:[ORGridLayoutContainer class]], @"Parsed screen should contain one grid layout");
}

- (void)testParseScreenWithGesture
{
    ORScreen *screen = [self parseValidXMLSnippet:@"<screen id=\"11\" name=\"Screen 11\"><gesture id=\"1\" type=\"swipe-top-to-bottom\"/></screen>"];
    
    STAssertNotNil(screen.identifier, @"Parsed screen should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], screen.identifier, @"Parsed screen should have 11 as identifer");
    STAssertEqualObjects(@"Screen 11", screen.name, @"Parsed screen should be named 'Screen 11'");
    STAssertEquals(ORScreenOrientationPortrait, screen.orientation, @"Parsed screen should be in portrait orientation");
    STAssertNil(screen.rotatedScreen, @"Parsed screen should not be linked to any screen for other orientation");
    
    STAssertNil(screen.background, @"Parsed screen should not have a background");
    STAssertEquals((NSUInteger)1, [screen.gestures count], @"Parsed screen should have a gesture");
    STAssertEquals((NSUInteger)0, [screen.layouts count], @"Parsed screen should not contain any layout");
}

@end