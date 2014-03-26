//
//  ButtonCommandDeferredBinding.m
//  openremote
//
//  Created by Eric Bariaux on 09/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ControllerComponentCommandDeferredBinding.h"
#import "Definition.h"
#import "LocalController.h"
#import "ControllerComponent.h"
#import "ORModelObject.h"

@interface ControllerComponentCommandDeferredBinding()

@property (nonatomic, strong) NSString *action;

@end

@implementation ControllerComponentCommandDeferredBinding

- (id)initWithBoundComponentIdentifier:(ORObjectIdentifier *)anIdentifier
                       enclosingObject:(ORModelObject *)anEnclosingObject
                                action:(NSString *)anAction
{
    self = [super initWithBoundComponentIdentifier:anIdentifier enclosingObject:anEnclosingObject];
    if (self) {
        self.action = anAction;
    }
    return self;
}

- (void)bind
{
    [((ControllerComponent *)self.enclosingObject) addCommand:[self.enclosingObject.definition.localController commandForIdentifier:self.boundComponentId] forAction:self.action];
}

@synthesize action;

@end