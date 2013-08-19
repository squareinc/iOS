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
    ORRESTError *error = [parser parseError];
    STAssertNotNil(error, @"Should return parsed error when provided with valid XML data");
    STAssertEquals(EPANEL_NAME_NOT_FOUND, error.code, @"Parsed error code should be 528");
    STAssertEqualObjects(@"No such Panel :NAME = panel  1", error.message, @"Parsed error message should be valid");
}

@end
