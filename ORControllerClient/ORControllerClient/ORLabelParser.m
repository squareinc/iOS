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

#import "ORLabelParser.h"
#import "ORLabel_Private.h"
#import "ORModelObject_Private.h"
#import "ORSensorRegistry.h"
#import "ORObjectIdentifier.h"

#import "UIColor+ORAdditions.h"
#import "ORSensorLinkParser.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "XMLEntity.h"
#import "ORSensor.h"

@interface ORLabelParser ()

@property (nonatomic, strong, readwrite) ORLabel *label;

@end


@implementation ORLabelParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:LINK];
        self.label = [[ORLabel alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                                    text:[attributeDict objectForKey:TEXT]];
        self.label.name = [attributeDict objectForKey:TEXT];
        if ([attributeDict objectForKey:COLOR]) {
            self.label.textColor = [UIColor or_ColorWithRGBString:[[attributeDict objectForKey:COLOR] substringFromIndex:1]];
        }
        if ([attributeDict objectForKey:FONT_SIZE]) {
            self.label.font = [UIFont fontWithName:@"Arial" size:[[attributeDict objectForKey:FONT_SIZE] intValue]];
        }
        self.label.definition = aRegister.definition;
    }
    return self;
}

- (void)endSensorLinkElement:(ORSensorLinkParser *)parser
{
    if (parser.sensor) {
        [self.depRegister.definition.sensorRegistry registerSensor:parser.sensor linkedToComponent:self.label property:@"text" sensorStatesMapping:parser.sensorStatesMapping];
    }
}

@synthesize label;

@end