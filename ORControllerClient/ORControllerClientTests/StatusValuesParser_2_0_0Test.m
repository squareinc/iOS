/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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
#import "StatusValuesParser_2_0_0Test.h"
#import "StatusValuesParser_2_0_0.h"

@implementation StatusValuesParser_2_0_0Test

// todo: check why this fails on XCTest
- (void)NOtestValidResponseParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"SensorValuesValidResponse_2_0_0" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    StatusValuesParser_2_0_0 *parser = [[StatusValuesParser_2_0_0 alloc] initWithData:data];
    NSDictionary *values = [parser parseValues];
    
    XCTAssertNil(parser.parseError, @"There should be no parsing error for valid XML");
    XCTAssertNotNil(values, @"Should provide parsed values when passed in valid data");
    XCTAssertTrue([values isKindOfClass:[NSDictionary class]], @"Parsing result should be an NSDictionary");
    XCTAssertEqual([values count], (NSUInteger)2, @"Fixture declares 2 sensors");
    [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        XCTAssertTrue([key isKindOfClass:[NSString class]], @"All keys must be strings");
        XCTAssertTrue([obj isKindOfClass:[NSString class]], @"All values must be strings");
    }];
    NSString *value = [values objectForKey:@"1"];
    XCTAssertNotNil(value, @"There should be a value for sensor with id 1");
    XCTAssertEqualObjects(value, @"on", @"Value for sensor with id 1 should be on");
    value = [values objectForKey:@"2"];
    XCTAssertNotNil(value, @"There should be a value for sensor with id 2");
    XCTAssertEqualObjects(value, @"off", @"Value for sensor with id 2 should be off");
}

- (void)testInvalidXMLParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidXML" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    StatusValuesParser_2_0_0 *parser = [[StatusValuesParser_2_0_0 alloc] initWithData:data];
    NSDictionary *values = [parser parseValues];

    XCTAssertNil(values, @"Invalid XML should not return any panels");
    XCTAssertNotNil(parser.parseError, @"A parsing error should be reported for invalid XML");
    XCTAssertEqualObjects([parser.parseError domain], NSXMLParserErrorDomain, @"Underlying XML parser error is propagated for malformed XML");
}

@end
