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

#import "ORColorPickerParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORColorPickerParser.h"
#import "ORImageParser.h"
#import "ORImage.h"
#import "DefinitionParserMock.h"
#import "ORObjectIdentifier.h"

@implementation ORColorPickerParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORColorPickerParser class] endSelector:@selector(setTopLevelParser:) forTag:COLORPICKER];
    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:IMAGE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:COLORPICKER];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORColorPicker *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORColorPickerParser class]], @"Parser used should be an ORColorPickerParser");
    ORColorPicker *colorPicker = ((ORColorPickerParser *)topLevelParser).colorPicker;
    XCTAssertNotNil(colorPicker, @"A color picker should be parsed for given XML snippet");
    
    return colorPicker;
}

- (void)testParseColorPickerNoImage
{
    ORColorPicker *colorPicker = [self parseValidXMLSnippet:@"<colorpicker id=\"10\"/>"];
    
    XCTAssertEqualObjects(colorPicker.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed color picker should have 10 as identifer");
    XCTAssertNil(colorPicker.image, @"Parsed color picker should not have an image defined");
}

- (void)testParseColorPickerWithImage
{
    ORColorPicker *colorPicker = [self parseValidXMLSnippet:@"<colorpicker id=\"10\"><image src=\"color.png\"/></colorpicker>"];
    
    XCTAssertEqualObjects(colorPicker.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed color picker should have 10 as identifer");
    XCTAssertNotNil(colorPicker.image, @"Parsed color picker should have an image defined");
    XCTAssertEqualObjects(colorPicker.image.src, @"color.png", @"Parsed color picker image src should be 'color.png'");
}

@end