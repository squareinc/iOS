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
#import "ORWebViewParser.h"
#import "ORWebView_Private.h"
#import "ORModelObject_Private.h"
#import "ORObjectIdentifier.h"
#import "ORSensorLinkParser.h"
#import "ORPanelDefinitionSensorRegistry.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "XMLEntity.h"

@interface ORWebViewParser ()

@property (nonatomic, strong, readwrite) ORWebView *web;

@end

@implementation ORWebViewParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:LINK];
        self.web = [[ORWebView alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                                 src:[attributeDict objectForKey:SRC]
                                            username:[attributeDict objectForKey:USERNAME]
                                            password:[attributeDict objectForKey:PASSWORD]];
        self.web.definition = aRegister.definition;
    }
    return self;
}

- (void)endSensorLinkElement:(ORSensorLinkParser *)parser
{
    if (parser.sensor) {
        [self.depRegister.definition.sensorRegistry registerSensor:parser.sensor linkedToComponent:self.web property:@"src" sensorStatesMapping:parser.sensorStatesMapping];
    }
}

@synthesize web;

@end