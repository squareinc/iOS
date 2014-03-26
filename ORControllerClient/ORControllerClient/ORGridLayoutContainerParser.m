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
#import "ORGridLayoutContainerParser.h"
#import "ORGridLayoutContainer_Private.h"
#import "ORGridCellParser.h"
#import "DefinitionElementParserRegister.h"

@interface ORGridLayoutContainerParser()

@property (nonatomic, strong, readwrite) ORGridLayoutContainer *layoutContainer;

@end

@implementation ORGridLayoutContainerParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:@"cell"];
        self.layoutContainer = [[ORGridLayoutContainer alloc] initWithLeft:[[attributeDict objectForKey:@"left"] integerValue]
                                                                     top:[[attributeDict objectForKey:@"top"] integerValue]
                                                                   width:[[attributeDict objectForKey:@"width"] integerValue]
                                                                  height:[[attributeDict objectForKey:@"height"] integerValue]
                                                                    rows:[[attributeDict objectForKey:@"rows"] integerValue]
                                                                    cols:[[attributeDict objectForKey:@"cols"] integerValue]];
        self.layoutContainer.definition = aRegister.definition;
    }
    return self;
}

- (void)endCellElement:(ORGridCellParser *)parser
{
    [((ORGridLayoutContainer *)self.layoutContainer).cells addObject:parser.cell];
}

@synthesize layoutContainer;

@end