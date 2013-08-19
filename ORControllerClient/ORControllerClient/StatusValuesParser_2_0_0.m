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

#import "StatusValuesParser_2_0_0.h"
#import "ORParser_Private.h"

@interface StatusValuesParser_2_0_0 ()

@property (nonatomic, strong) NSMutableDictionary *_sensorValues;

@property (nonatomic, strong) NSMutableString *_currentValue;
@property (nonatomic, copy) NSString *_currentId;

@end

@implementation StatusValuesParser_2_0_0

- (NSDictionary *)parseValues
{
    self._sensorValues = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (![self doParsing]) {
        return nil;
    }
    
    return [NSDictionary dictionaryWithDictionary:self._sensorValues];
}

#pragma mark delegate method of NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"status"]) {
		self._currentId = [[attributeDict valueForKey:@"id"] copy];
        self._currentValue = [NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self._currentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"status"]) {
        // TODO: why the trimming, if appropriate -> must be documented in API
        NSString *status = [self._currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (self._currentId) {
            [self._sensorValues setObject:status forKey:self._currentId];
        }
    }
}

@end
