//
//  ControllerVersionSelectAPI.h
//  openremote
//
//  Created by Eric Bariaux on 19/04/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORControllerConfig;

@interface ControllerVersionSelectAPI : NSObject

- (id)initWithController:(ORControllerConfig *)aController APIProtocol:(Protocol *)protocol;

@end