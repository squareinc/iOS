//
//  ControllerSliderParser.m
//  openremote
//
//  Created by Eric Bariaux on 09/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ControllerSliderParser.h"
#import "ControllerComponent.h"
#import "ControllerComponentCommandDeferredBinding.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"

@implementation ControllerSliderParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict;
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        self.slider = [[ControllerComponent alloc] initWithId:[[attributeDict objectForKey:ID] intValue]];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"ctrl:include"] && [@"command" isEqualToString:[attributeDict objectForKey:TYPE]]) {
        // This is a reference to another element, will be resolved later, put a standby in place for now
        ControllerComponentCommandDeferredBinding *standby = [[ControllerComponentCommandDeferredBinding alloc] initWithBoundComponentIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:REF]] enclosingObject:self.slider action:@"setValue"];
        self.slider.definition = self.depRegister.definition;
        [self.depRegister addDeferredBinding:standby];
    }
    // We do not care about parsing the sensor information from this element, it is already included in the "UI" slider and parsed by the SliderParser
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@synthesize slider;

@end