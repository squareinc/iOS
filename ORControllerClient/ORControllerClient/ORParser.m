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

#import "ORParser.h"

@interface ORParser ()

@property (nonatomic, strong) NSData *_data;
@property (nonatomic, strong, readwrite) NSError *parseError;

@end

@implementation ORParser

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self._data = data;
        self.parseError = nil;
    }
    return self;
}

- (BOOL)doParsing
{
    self.parseError = nil;
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	[xmlParser setDelegate:self];
	if (![xmlParser parse]) {
        self.parseError = [xmlParser parserError];
        return NO;
    }
    return YES;
}

@end
