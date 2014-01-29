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

#import "ORBackgroundParserTest.h"
#import "ORBackgroundParser.h"
#import "ORImageParser.h"
#import "DefinitionElementParserRegister.h"
#import "DefinitionParserMock.h"
#import "ORBackground.h"
#import "oRImage.h"

@implementation ORBackgroundParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORBackgroundParser class] endSelector:@selector(setTopLevelParser:) forTag:@"background"];
    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:@"image"];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:@"background"];
    [xmlParser setDelegate:parser];
    [xmlParser parse];

    return parser.topLevelParser;
}
- (ORBackground *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORBackgroundParser class]], @"Parser used should be an ORBackgroundParser");
    ORBackground *background = ((ORBackgroundParser *)topLevelParser).background;
    STAssertNotNil(background, @"A background should be parsed for given XML snippet");

    return background;
}

- (void)testParseFillScreenBackground
{
    ORBackground *background = [self parseValidXMLSnippet:@"<background fillScreen=\"true\"><image src=\"test.png\"/></background>"];
    
    STAssertNotNil(background.image, @"Parsed background should have an image");
    STAssertEqualObjects(background.image.name, @"test.png", @"Parsed background image shoud be named 'test.png'");
    
    STAssertEquals(background.repeat, ORBackgroundRepeatNoRepeat, @"Parsed background image should not repeat");
    STAssertEquals(background.size, CGSizeMake(100.0, 100.0), @"Parsed background image must fill container");
    STAssertEquals(background.sizeUnit, ORWidgetUnitPercentage, @"Parsed background image size must be relative to its container");
}

- (void)testParseFillScreenDefaultsToTrue
{
    ORBackground *background = [self parseValidXMLSnippet:@"<background><image src=\"test.png\"/></background>"];
    
    STAssertNotNil(background.image, @"Parsed background should have an image");
    STAssertEqualObjects(background.image.name, @"test.png", @"Parsed background image shoud be named 'test.png'");
    
    STAssertEquals(background.repeat, ORBackgroundRepeatNoRepeat, @"Parsed background image should not repeat");
    STAssertEquals(background.size, CGSizeMake(100.0, 100.0), @"Parsed background image must fill container");
    STAssertEquals(background.sizeUnit, ORWidgetUnitPercentage, @"Parsed background image size must be relative to its container");
}

- (void)validateExpectedRelativePosition:(CGPoint)expectedPosition
                             description:(NSString *)expectedPositionStr
                           forBackground:(ORBackground *)background
{
    STAssertNotNil(background.image, @"Parsed background should have an image");
    STAssertEqualObjects(background.image.name, @"test.png", @"Parsed background image shoud be named 'test.png'");
    
    STAssertEquals(background.repeat, ORBackgroundRepeatNoRepeat, @"Parsed background image should not repeat");
    STAssertEquals(background.position, expectedPosition, @"Parsed background image must be %@ positioned", expectedPositionStr);
    STAssertEquals(background.positionUnit, ORWidgetUnitPercentage, @"Parsed background image position must be relative");
    STAssertEquals(background.sizeUnit, ORWidgetUnitNotDefined, @"Parsed background image size must not be defined");
}

- (void)testParseRelativeScreenBackgrounds
{
    ORBackground *background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"LEFT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(0.0, 50.0) description:@"left" forBackground:background];
    
    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"RIGHT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(100.0, 50.0) description:@"right" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"TOP\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(50.0, 0.0) description:@"top" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"BOTTOM\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(50.0, 100.0) description:@"bottom" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"TOP_LEFT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(0.0, 0.0) description:@"top left" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"TOP_RIGHT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(100.0, 0.0) description:@"top right" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"BOTTOM_LEFT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(0.0, 100.0) description:@"bottom left" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"BOTTOM_RIGHT\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(100.0, 100.0) description:@"bottom right" forBackground:background];

    background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" relative=\"CENTER\"><image src=\"test.png\"/></background>"];
    [self validateExpectedRelativePosition:CGPointMake(50.0, 50.0) description:@"center" forBackground:background];
}

- (void)testParseAbsoluteScreenBackground
{
    ORBackground *background = [self parseValidXMLSnippet:@"<background fillScreen=\"false\" absolute=\"20,30\"><image src=\"test.png\"/></background>"];
    
    STAssertNotNil(background.image, @"Parsed background should have an image");
    STAssertEqualObjects(background.image.name, @"test.png", @"Parsed background image shoud be named 'test.png'");
    
    STAssertEquals(background.repeat, ORBackgroundRepeatNoRepeat, @"Parsed background image should not repeat");
    STAssertEquals(background.position, CGPointMake(20.0, 30.0), @"Parsed background image must be positioned at 20,30");
    STAssertEquals(background.positionUnit, ORWidgetUnitLength, @"Parsed background image position must be absolute");
    STAssertEquals(background.sizeUnit, ORWidgetUnitNotDefined, @"Parsed background image size must not be defined");
}

@end