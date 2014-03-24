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
#import "ORColorPickerParser.h"
#import "ORColorPicker.h"
#import "ORObjectIdentifier.h"
#import "ORImageParser.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"

@interface ORColorPickerParser ()

@property (nonatomic, strong, readwrite) ORColorPicker *colorPicker;

@end

@implementation ORColorPickerParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:IMAGE];
        self.colorPicker = [[ORColorPicker alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:@"id"]]];
        self.colorPicker.definition = aRegister.definition;
    }
    return self;
}

- (void)endImageElement:(ORImageParser *)parser
{
    self.colorPicker.image = parser.image;
}

@synthesize colorPicker;

@end