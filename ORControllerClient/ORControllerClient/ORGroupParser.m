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
#import "ORGroupParser.h"
#import "ORGroup_Private.h"
#import "DefinitionElementParserRegister.h"
#import "ORGroupScreenDeferredBinding.h"
#import "ORObjectIdentifier.h"
#import "ORTabBarParser.h"
#import "XMLEntity.h"

@interface ORGroupParser ()

@property (nonatomic, strong, readwrite) ORGroup *group;

@end

@implementation ORGroupParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict;
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:TABBAR];
        self.group = [[ORGroup alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                                         name:[attributeDict objectForKey:NAME]];
        self.group.definition = aRegister.definition;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:INCLUDE] && [SCREEN isEqualToString:[attributeDict objectForKey:TYPE]]) {
        // This is a reference to another element, will be resolved later, put a standby in place for now
        ORGroupScreenDeferredBinding *standby = [[ORGroupScreenDeferredBinding alloc]
                                                 initWithBoundComponentId:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:REF]]
                                                 enclosingObject:self.group];
        [self.depRegister addDeferredBinding:standby];
	}
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

- (void)endTabBarElement:(ORTabBarParser *)parser
{
    self.group.tabBar = parser.tabBar;
}

@synthesize group;

@end