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
#import "ORSwitchParser.h"
#import "ORSwitch.h"
#import "ORModelObject_Private.h"
#import "ORWidget_Private.h"
#import "ORObjectIdentifier.h"
#import "ORSensorLinkParser.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "XMLEntity.h"
#import "ORSensorRegistry.h"
#import "ORSensorStatesMapping.h"
#import "ORImage.h"

@interface ORSwitchParser ()

@property (nonatomic, strong, readwrite) ORSwitch *sswitch;

@end

@implementation ORSwitchParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:LINK];
        self.sswitch = [[ORSwitch alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]];
        self.sswitch.definition = aRegister.definition;
    }
    return self;
}

- (void)endSensorLinkElement:(ORSensorLinkParser *)parser
{
    if (parser.sensor) {
        [self.depRegister.definition.sensorRegistry registerSensor:parser.sensor linkedToComponent:self.sswitch property:@"state" sensorStatesMapping:parser.sensorStatesMapping];
        
        NSString *onImageName = [parser.sensorStatesMapping stateValueForName:@"on"];
        if (onImageName) {
            [self.depRegister.definition addImageName:onImageName];
            self.sswitch.onImage = [[ORImage alloc] initWithIdentifier:nil name:onImageName];
        }
        
        NSString *offImageName = [parser.sensorStatesMapping stateValueForName:@"off"];
        if (offImageName) {
            [self.depRegister.definition addImageName:offImageName];
            self.sswitch.offImage = [[ORImage alloc] initWithIdentifier:nil name:offImageName];
        }
    }
}

@synthesize sswitch;

@end