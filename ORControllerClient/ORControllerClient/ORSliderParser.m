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

#import "ORSliderParser.h"
#import "DefinitionElementParserRegister.h"
#import "ORSensorRegistry.h"
#import "Definition.h"
#import "ORSensorLinkParser.h"
#import "ORSlider_Private.h"
#import "ORObjectIdentifier.h"
#import "ORImage.h"
#import "XMLEntity.h"

@interface ORSliderParser ()

@property (nonatomic, strong, readwrite) ORSlider *slider;

@end

@implementation ORSliderParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:LINK];
        [self.depRegister.definition addImageName:[attributeDict objectForKey:THUMB_IMAGE]];
        self.slider = [[ORSlider alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                        vertical:[@"true" isEqualToString:[[attributeDict objectForKey:VERTICAL] lowercaseString]]
                                         passive:[@"true" isEqualToString:[[attributeDict objectForKey:PASSIVE] lowercaseString]]
                                   thumbImageSrc:[attributeDict objectForKey:THUMB_IMAGE]];
        self.slider.definition = self.depRegister.definition;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	ORImage *img = [[ORImage alloc] initWithIdentifier:nil name:[attributeDict objectForKey:IMAGE]];
    [self.depRegister.definition addImageName:img.name];
    
	ORImage *trackImg = [[ORImage alloc] initWithIdentifier:nil name:[attributeDict objectForKey:TRACK_IMAGE]];
    [self.depRegister.definition addImageName:trackImg.name];
	if ([elementName isEqualToString:MIN_VALUE]) {
		self.slider.minValue = [[attributeDict objectForKey:VALUE] floatValue];
		self.slider.minImage = img;
		self.slider.minTrackImage = trackImg;
	} else if ([elementName isEqualToString:MAX_VALUE]) {
		self.slider.maxValue = [[attributeDict objectForKey:VALUE] floatValue];
		self.slider.maxImage = img;
		self.slider.maxTrackImage = trackImg;
	}
    
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

- (void)endSensorLinkElement:(ORSensorLinkParser *)parser
{
    if (parser.sensor) {
        [self.depRegister.definition.sensorRegistry registerSensor:parser.sensor linkedToComponent:self.slider property:@"_value" sensorStatesMapping:parser.sensorStatesMapping];
    }
}

@synthesize slider;

@end