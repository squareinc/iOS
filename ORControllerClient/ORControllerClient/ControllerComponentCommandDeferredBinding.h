//
//  ButtonCommandDeferredBinding.h
//  openremote
//
//  Created by Eric Bariaux on 09/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ORDeferredBinding.h"

@interface ControllerComponentCommandDeferredBinding : ORDeferredBinding

- (id)initWithBoundComponentIdentifier:(ORObjectIdentifier *)anIdentifier
                       enclosingObject:(ORModelObject *)anEnclosingObject
                                action:(NSString *)anAction;

@end