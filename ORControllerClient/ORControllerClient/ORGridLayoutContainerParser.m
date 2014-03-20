/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "ORGridLayoutContainer.h"
#import "GridCellParser.h"

@interface ORGridLayoutContainerParser()

@property (nonatomic, strong, readwrite) ORGridLayoutContainer *layoutContainer;

@end

/**
 * Store gridcell model and parsed from element grid in panel.xml.
 * XML fragment example:
 * <grid left="20" top="20" width="300" height="400" rows="2" cols="2">
 *    <cell x="0" y="0" rowspan="1" colspan="1">
 *    </cell>
 * </grid>
 */
@implementation ORGridLayoutContainerParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:@"cell"];
        self.layoutContainer = [[ORGridLayoutContainer alloc] initWithLeft:[[attributeDict objectForKey:@"left"] integerValue]
                                                                     top:[[attributeDict objectForKey:@"top"] integerValue]
                                                                   width:[[attributeDict objectForKey:@"width"] unsignedIntegerValue]
                                                                  height:[[attributeDict objectForKey:@"height"] unsignedIntegerValue]
                                                                    rows:[[attributeDict objectForKey:@"rows"] unsignedIntegerValue]
                                                                    cols:[[attributeDict objectForKey:@"cols"] unsignedIntegerValue]];
    }
    return self;
}

- (void)endCellElement:(GridCellParser *)parser
{
    [((ORGridLayoutContainer *)self.layoutContainer).cells addObject:parser.gridCell];
}

@synthesize layoutContainer;

@end