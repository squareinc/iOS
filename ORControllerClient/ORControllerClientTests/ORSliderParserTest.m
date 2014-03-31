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
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORSliderParser class]], @"Parser used should be an ORSliderParser");
    ORSlider *slider = ((ORSliderParser *)topLevelParser).slider;
    STAssertNotNil(slider, @"A slider should be parsed for given XML snippet");
    
    return slider;
}

- (void)testParseSliderDefaultValuesNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\"/>"];
    
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
}

- (void)testParseVerticalPassiveSliderWithThumbImageNoBoundsNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\" thumbImage=\"Image.png\" vertical=\"true\" passive=\"true\"/>"];
    
    STAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], slider.identifier, @"Parsed slider should have 10 as identifer");
    
    STAssertTrue(slider.passive, @"Parsed slider should be passive");
    STAssertTrue(slider.vertical, @"Parsed slider should be vertical");
    
    STAssertEquals(0.0f, slider.minValue, @"Parser slider should have default minimum bound of 0");
    STAssertEquals(100.0f, slider.maxValue, @"Parser slider should have default maximum bound of 100");
    
    STAssertNotNil(slider.thumbImage, @"Parsed slider should have a thumb image defined");
    STAssertEqualObjects(@"Image.png", slider.thumbImage.src, @"Parsed slider thumb image src should be 'Image.png'");
    
    STAssertNil(slider.minImage, @"Parsed slider should not have any min image defined");
    STAssertNil(slider.minTrackImage, @"Parsed slider should not have any min track image defined");
    STAssertNil(slider.maxImage, @"Parsed slider should not have any max image defined");
    STAssertNil(slider.maxTrackImage, @"Parsed slider should not have any max track min image defined");
}

- (void)testParseSliderNoSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\" thumbImage=\"Image.png\"><min value=\"-10\" image=\"min.png\" trackImage=\"min_track.png\"/><max value=\"60\" image=\"max.png\" trackImage=\"max_track.png\"/></slider>"];
    
    STAssertNotNil(slider.identifier, @"Parsed slider should have an identifier");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:10], slider.identifier, @"Parsed slider should have 10 as identifer");
    
    STAssertFalse(slider.passive, @"Parsed slider should not be passive by default");
    STAssertFalse(slider.vertical, @"Parsed slider should be horizontal by default");
    
    STAssertEquals(-10.0f, slider.minValue, @"Parser slider should have minimum bound of -10");
    STAssertEquals(60.0f, slider.maxValue, @"Parser slider should have maximum bound of 60");
    
    STAssertNotNil(slider.thumbImage, @"Parsed slider should have a thumb image defined");
    STAssertEqualObjects(@"Image.png", slider.thumbImage.src, @"Parsed slider thumb image src should be 'Image.png'");
    
    STAssertNotNil(slider.minImage, @"Parsed slider should have a min image defined");
    STAssertEqualObjects(@"min.png", slider.minImage.src, @"Parsed slider min image src should be 'min.png'");
    
    STAssertNotNil(slider.minTrackImage, @"Parsed slider should have a min track image defined");
    STAssertEqualObjects(@"min_track.png", slider.minTrackImage.src, @"Parsed slider min track image src should be 'min_track.png'");
    
    STAssertNotNil(slider.maxImage, @"Parsed slider should have a max image defined");
    STAssertEqualObjects(@"max.png", slider.maxImage.src, @"Parsed slider max image src should be 'max.png'");
    
    STAssertNotNil(slider.maxTrackImage, @"Parsed slider should have a max track min image defined");
    STAssertEqualObjects(@"max_track.png", slider.maxTrackImage.src, @"Parsed slider max track image src should be 'max_track.png'");
}

- (void)testParseSliderDefaultValuesWithSensor
{
    ORSlider *slider = [self parseValidXMLSnippet:@"<slider id=\"10\"><link type=\"sensor\" ref=\"60\"/></slider>"];
    
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
}

@end