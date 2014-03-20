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
#import "DefinitionParser.h"
#import "GroupParser.h"
#import "ORScreenParser.h"
#import "ORTabBarParser.h"
#import "LocalParser.h"
#import "Definition.h"
#import "DefinitionElementParserRegister.h"

@interface DefinitionParser()

@property (nonatomic, strong, readwrite) Definition *definition;

@end

@implementation DefinitionParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict;
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:@"screen"];
        [self addKnownTag:@"group"];
        [self addKnownTag:@"tabbar"];
        [self addKnownTag:@"local"];
        self.definition = [[Definition alloc] init];
        aRegister.definition = self.definition;
    }
    return self;
}

- (void)endScreenElement:(ORScreenParser *)screenParser
{
    [self.definition addScreen:screenParser.screen];
}

- (void)endGroupElement:(GroupParser *)groupParser
{
    [self.definition addGroup:groupParser.group];
}

- (void)endTabBarElement:(ORTabBarParser *)tabBarParser
{
    self.definition.tabBar = tabBarParser.tabBar;
}

- (void)endLocalElement:(LocalParser *)localParser
{
    self.definition.localController = localParser.localController;
}

- (NSString *)handledTag
{
    return @"definition";
}

@synthesize definition;

@end