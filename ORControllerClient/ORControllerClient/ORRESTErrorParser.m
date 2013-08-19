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

#import "ORRESTErrorParser.h"
#import "ORRESTError.h"

@interface ORRESTErrorParser ()

@property (nonatomic, strong) NSData *_data;

@property (nonatomic, strong) NSMutableString *_currentValue;

@property (nonatomic, strong) NSString *_message;
@property (nonatomic) NSInteger _code;

@end

@implementation ORRESTErrorParser

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self._data = data;
    }
    return self;
}

- (ORRESTError *)parseError
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	[xmlParser setDelegate:self];
	[xmlParser parse];
    
    return [[ORRESTError alloc] initWithMessage:self._message code:self._code];
}

#pragma mark delegate method of NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"code"] || ([elementName isEqualToString:@"message"])) {
        self._currentValue = [NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self._currentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"code"]) {
        self._code = [self._currentValue integerValue];
        self._currentValue = nil; // Must nil _currentValue or it will continue to collect characters from outside the tag
    } else if ([elementName isEqualToString:@"message"]) {
        self._message = self._currentValue;
        self._currentValue = nil; // Must nil _currentValue or it will continue to collect characters from outside the tag
    }
}

@end
