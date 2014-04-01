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

#import "ORGestureParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORGestureParser.h"
#import "ORNavigationParser.h"
#import "ORGesture_Private.h"
#import "ORObjectIdentifier.h"

@implementation ORGestureParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORGestureParser class] endSelector:@selector(setTopLevelParser:) forTag:GESTURE];
    [depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(endNavigateElement:) forTag:NAVIGATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:GESTURE];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORGesture *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORGestureParser class]], @"Parser used should be an ORGestureParser");
    ORGesture *gesture = ((ORGestureParser *)topLevelParser).gesture;
    STAssertNotNil(gesture, @"A gesture should be parsed for given XML snippet");
    
    return gesture;
}

- (void)testParseGestureNoCommandNoNavigation
{
    ORGesture *gesture = [self parseValidXMLSnippet:@"<gesture id=\"10\" type=\"swipe-bottom-to-top\"/>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed gesture should have 10 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeBottomToTop, @"Parsed gesture should be a bottom to top swipe");
    
    STAssertNil(gesture.navigation, @"Parsed gesture should not have any navigation");
    STAssertFalse(gesture.hasCommand, @"Parsed gesture should not have any command");
    
    gesture = [self parseValidXMLSnippet:@"<gesture id=\"11\" type=\"swipe-top-to-bottom\"/>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Parsed gesture should have 11 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeTopToBottom, @"Parsed gesture should be a top to bottom swipe");
    
    STAssertNil(gesture.navigation, @"Parsed gesture should not have any navigation");
    STAssertFalse(gesture.hasCommand, @"Parsed gesture should not have any command");
    
    gesture = [self parseValidXMLSnippet:@"<gesture id=\"12\" type=\"swipe-left-to-right\"/>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:12], @"Parsed gesture should have 12 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeLeftToRight, @"Parsed gesture should be a left to right swipe");
    
    STAssertNil(gesture.navigation, @"Parsed gesture should not have any navigation");
    STAssertFalse(gesture.hasCommand, @"Parsed gesture should not have any command");
    
    gesture = [self parseValidXMLSnippet:@"<gesture id=\"13\" type=\"swipe-right-to-left\"/>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:13], @"Parsed gesture should have 13 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeRightToLeft, @"Parsed gesture should be a right to left swipe");
    
    STAssertNil(gesture.navigation, @"Parsed gesture should not have any navigation");
    STAssertFalse(gesture.hasCommand, @"Parsed gesture should not have any command");
}

- (void)testParseGestureWithCommandNoNavigation
{
    ORGesture *gesture = [self parseValidXMLSnippet:@"<gesture id=\"10\" type=\"swipe-bottom-to-top\" hasControlCommand=\"true\"/>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed gesture should have 10 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeBottomToTop, @"Parsed gesture should be a bottom to top swipe");
    
    STAssertNil(gesture.navigation, @"Parsed gesture should not have any navigation");
    STAssertTrue(gesture.hasCommand, @"Parsed gesture should have a command");
}

- (void)testParseGestureNoCommandWithNavigation
{
    ORGesture *gesture = [self parseValidXMLSnippet:@"<gesture id=\"10\" type=\"swipe-bottom-to-top\"><navigate to=\"setting\"/></gesture>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed gesture should have 10 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeBottomToTop, @"Parsed gesture should be a bottom to top swipe");
    
    STAssertNotNil(gesture.navigation, @"Parsed gesture should have a navigation");
    STAssertFalse(gesture.hasCommand, @"Parsed gesture should not have any command");
}

- (void)testParseGestureWithCommandAndNavigation
{
    ORGesture *gesture = [self parseValidXMLSnippet:@"<gesture id=\"10\" type=\"swipe-bottom-to-top\" hasControlCommand=\"true\"><navigate to=\"setting\"/></gesture>"];
    
    STAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed gesture should have 10 as identifer");
    STAssertEquals(gesture.gestureType, ORGestureTypeSwipeBottomToTop, @"Parsed gesture should be a bottom to top swipe");
    
    STAssertNotNil(gesture.navigation, @"Parsed gesture should have a navigation");
    STAssertTrue(gesture.hasCommand, @"Parsed gesture should have a command");
}

@end