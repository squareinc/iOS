//
//  ControllerSwitchParser.m
//  openremote
//
//  Created by Eric Bariaux on 09/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ControllerSwitchParser.h"
#import "ORModelObject_Private.h"
#import "ControllerComponent.h"
#import "ControllerComponentCommandDeferredBinding.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"
#import "ORWidget_Private.h"

@interface ControllerSwitchParser()

@property (nonatomic, strong) NSString *action;

@end

@implementation ControllerSwitchParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict;
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        self.theSwitch = [[ControllerComponent alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ctrl:on"]) {
        self.action = @"ON";
    } else if ([elementName isEqualToString:@"ctrl:off"]) {
        self.action = @"OFF";
    } else if ([elementName isEqualToString:@"ctrl:include"] && [@"command" isEqualToString:[attributeDict objectForKey:TYPE]]) {
        // This is a reference to another element, will be resolved later, put a standby in place for now
        ControllerComponentCommandDeferredBinding *standby = [[ControllerComponentCommandDeferredBinding alloc] initWithBoundComponentIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:REF]] enclosingObject:self.theSwitch action:self.action];
        self.theSwitch.definition = self.depRegister.definition;
        [self.depRegister addDeferredBinding:standby];
	}
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@synthesize theSwitch;
@synthesize action;

@end