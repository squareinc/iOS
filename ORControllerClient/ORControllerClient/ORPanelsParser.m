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

#import "ORPanelsParser.h"
#import "ORPanel.h"

@interface ORPanelsParser ()

@property (nonatomic, strong) NSData *_data;
@property (nonatomic, strong) NSMutableArray *_panels;
@property (nonatomic, strong, readwrite) NSError *parseError;

@end

@implementation ORPanelsParser

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self._data = data;
        self.parseError = nil;
    }
    return self;
}

- (NSArray *)parsePanels
{
    self._panels = [NSMutableArray arrayWithCapacity:1];
    self.parseError = nil;
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	[xmlParser setDelegate:self];
	if (![xmlParser parse]) {
        self.parseError = [xmlParser parserError];
        return nil;
    }
    
    return [NSArray arrayWithArray:self._panels];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"panel"]) {
        // TODO: take id into account
        ORPanel *panel = [[ORPanel alloc] init];
        panel.name = [attributeDict valueForKey:@"name"];
		[self._panels addObject:panel];
	}
}

@end
