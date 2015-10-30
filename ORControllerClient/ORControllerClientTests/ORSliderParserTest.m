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

#import "ORSliderParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORSliderParser.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "DefinitionParserMock.h"
#import "ORSlider.h"
#import "ORImage.h"
#import "ORObjectIdentifier.h"

@implementation ORSliderParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORSliderParser class] endSelector:@selector(setTopLevelParser:) forTag:SLIDER];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:SLIDER];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORSlider *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORSliderParser class]], @"Parser used should be an ORSliderParser");
    ORSlider *slider = ((ORSliderParser *)topLevelParser).slider;
    XCTAssertNotNil(slider, @"A slider should be parsed for given XML snippet");
    
    return slider;
}

- (void)testParseSliderDefaultValuesNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\"/>"];
    
    XCTAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    XCTAssertEqualObjects(slider.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed slider should have 10 as identifer");
    
    XCTAssertFalse(slider.passive, @"Parsed slider should not be passive by default");
    XCTAssertFalse(slider.vertical, @"Parsed slider should be horizontal by default");
    
    XCTAssertEqual(slider.minValue, 0.0f, @"Parser slider should have default minimum bound of 0");
    XCTAssertEqual(slider.maxValue, 100.0f, @"Parser slider should have default maximum bound of 100");
    
    XCTAssertNil(slider.thumbImage, @"Parsed slider should not have any thumb image defined");
    XCTAssertNil(slider.minImage, @"Parsed slider should not have any min image defined");
    XCTAssertNil(slider.minTrackImage, @"Parsed slider should not have any min track image defined");
    XCTAssertNil(slider.maxImage, @"Parsed slider should not have any max image defined");
    XCTAssertNil(slider.maxTrackImage, @"Parsed slider should not have max track min image defined");
}

- (void)testParseVerticalPassiveSliderWithThumbImageNoBoundsNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\" thumbImage=\"Image.png\" vertical=\"true\" passive=\"true\"/>"];
    
    XCTAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    XCTAssertEqualObjects(slider.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed slider should have 10 as identifer");
    
    XCTAssertTrue(slider.passive, @"Parsed slider should be passive");
    XCTAssertTrue(slider.vertical, @"Parsed slider should be vertical");
    
    XCTAssertEqual(slider.minValue, 0.0f, @"Parser slider should have default minimum bound of 0");
    XCTAssertEqual(slider.maxValue, 100.0f, @"Parser slider should have default maximum bound of 100");
    
    XCTAssertNotNil(slider.thumbImage, @"Parsed slider should have a thumb image defined");
    XCTAssertEqualObjects(slider.thumbImage.src, @"Image.png", @"Parsed slider thumb image src should be 'Image.png'");
    
    XCTAssertNil(slider.minImage, @"Parsed slider should not have any min image defined");
    XCTAssertNil(slider.minTrackImage, @"Parsed slider should not have any min track image defined");
    XCTAssertNil(slider.maxImage, @"Parsed slider should not have any max image defined");
    XCTAssertNil(slider.maxTrackImage, @"Parsed slider should not have any max track min image defined");
}

- (void)testParseSliderNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\" thumbImage=\"Image.png\"><min value=\"-10\" image=\"min.png\" trackImage=\"min_track.png\"/><max value=\"60\" image=\"max.png\" trackImage=\"max_track.png\"/></slider>"];
    
    XCTAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    XCTAssertEqualObjects(slider.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed slider should have 10 as identifer");
    
    XCTAssertFalse(slider.passive, @"Parsed slider should not be passive by default");
    XCTAssertFalse(slider.vertical, @"Parsed slider should be horizontal by default");
    
    XCTAssertEqual(slider.minValue, -10.0f, @"Parser slider should have minimum bound of -10");
    XCTAssertEqual(slider.maxValue, 60.0f, @"Parser slider should have maximum bound of 60");
    
    XCTAssertNotNil(slider.thumbImage, @"Parsed slider should have a thumb image defined");
    XCTAssertEqualObjects(slider.thumbImage.src, @"Image.png", @"Parsed slider thumb image src should be 'Image.png'");
    
    XCTAssertNotNil(slider.minImage, @"Parsed slider should have a min image defined");
    XCTAssertEqualObjects(slider.minImage.src, @"min.png", @"Parsed slider min image src should be 'min.png'");
    
    XCTAssertNotNil(slider.minTrackImage, @"Parsed slider should have a min track image defined");
    XCTAssertEqualObjects(slider.minTrackImage.src, @"min_track.png", @"Parsed slider min track image src should be 'min_track.png'");
    
    XCTAssertNotNil(slider.maxImage, @"Parsed slider should have a max image defined");
    XCTAssertEqualObjects(slider.maxImage.src, @"max.png", @"Parsed slider max image src should be 'max.png'");
    
    XCTAssertNotNil(slider.maxTrackImage, @"Parsed slider should have a max track min image defined");
    XCTAssertEqualObjects(slider.maxTrackImage.src, @"max_track.png", @"Parsed slider max track image src should be 'max_track.png'");
}

- (void)testParseSliderDefaultValuesWithSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\"><link type=\"sensor\" ref=\"60\"/></slider>"];
    
    XCTAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    XCTAssertEqualObjects(slider.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed slider should have 10 as identifer");
    
    XCTAssertFalse(slider.passive, @"Parsed slider should not be passive by default");
    XCTAssertFalse(slider.vertical, @"Parsed slider should be horizontal by default");
    
    XCTAssertEqual(slider.minValue, 0.0f, @"Parser slider should have default minimum bound of 0");
    XCTAssertEqual(slider.maxValue, 100.0f, @"Parser slider should have default maximum bound of 100");
    
    XCTAssertNil(slider.thumbImage, @"Parsed slider should not have any thumb image defined");
    XCTAssertNil(slider.minImage, @"Parsed slider should not have any min image defined");
    XCTAssertNil(slider.minTrackImage, @"Parsed slider should not have any min track image defined");
    XCTAssertNil(slider.maxImage, @"Parsed slider should not have any max image defined");
    XCTAssertNil(slider.maxTrackImage, @"Parsed slider should not have max track min image defined");
}

@end