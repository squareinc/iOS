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

#import "ORRESTErrorParserTest.h"
#import "ORRESTErrorParser.h"
#import "ORRESTError.h"

@implementation ORRESTErrorParserTest

- (void)testValidErrorParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"RESTCallErrorResponse" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORRESTErrorParser *parser = [[ORRESTErrorParser alloc] initWithData:data];
    ORRESTError *error = [parser parseRESTError];

    XCTAssertNil(parser.parseError, @"There should be no parsing error for valid XML");
    XCTAssertNotNil(error, @"Should return parsed error when provided with valid XML data");
    XCTAssertEqual(error.code, (NSInteger)EPANEL_NAME_NOT_FOUND, @"Parsed error code should be 528");
    XCTAssertEqualObjects(error.message, @"No such Panel :NAME = panel  1", @"Parsed error message should be valid");
}

- (void)testInvalidXMLParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"InvalidXML" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORRESTErrorParser *parser = [[ORRESTErrorParser alloc] initWithData:data];
    ORRESTError *error = [parser parseRESTError];
    XCTAssertNil(error, @"Invalid XML should not return any panels");
    XCTAssertNotNil(parser.parseError, @"A parsing error should be reported for invalid XML");
    XCTAssertEqualObjects([parser.parseError domain], NSXMLParserErrorDomain, @"Underlying XML parser error is propagated for malformed XML");
}

@end
