//
//  ControllerComponentParser.m
//  openremote
//
//  Created by Eric Bariaux on 04/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ControllerButtonParser.h"
#import "ControllerComponent.h"
#import "ControllerComponentCommandDeferredBinding.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"

@implementation ControllerButtonParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict;
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        self.button = [[ControllerComponent alloc] initWithId:[[attributeDict objectForKey:ID] intValue]];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"ctrl:include"] && [@"command" isEqualToString:[attributeDict objectForKey:TYPE]]) {
        // This is a reference to another element, will be resolved later, put a standby in place for now
        ControllerComponentCommandDeferredBinding *standby = [[ControllerComponentCommandDeferredBinding alloc] initWithBoundComponentIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:REF]] enclosingObject:self.button action:@"click"];
        
        // TODO: click is only valid for 2.0 API, must check for 2.1 (long button press support)
        
        self.button.definition = self.depRegister.definition;
        [self.depRegister addDeferredBinding:standby];
	}
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@synthesize button;

@end