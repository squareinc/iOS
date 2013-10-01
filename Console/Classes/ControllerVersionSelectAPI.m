//
//  ControllerVersionSelectAPI.m
//  openremote
//
//  Created by Eric Bariaux on 19/04/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "ControllerVersionSelectAPI.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

@interface ControllerVersionSelectAPI ()

@property (nonatomic, retain) Protocol *apiProtocol;
@property (nonatomic, retain) id implementingObject;
@property (nonatomic, copy) NSString *versionUsed;

@property (nonatomic, assign) ORControllerConfig *controller;
@end

@implementation ControllerVersionSelectAPI

- (id)initWithController:(ORControllerConfig *)aController APIProtocol:(Protocol *)protocol
{
    self = [super init];
    if (self) {
        self.apiProtocol = protocol;
        self.controller = aController;
    }
    return self;
}

- (void)dealloc
{
    self.apiProtocol = nil;
    self.implementingObject = nil;
    self.versionUsed = nil;
    self.controller = nil;
    [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *version = self.controller.controllerAPIVersion;
    if (![self.versionUsed isEqualToString:version] || !self.implementingObject) {
        
        
        self.versionUsed = version;
        NSLog(@"Using version %@", self.versionUsed);
        NSString *className = [NSString stringWithFormat:@"%@_v%@", NSStringFromProtocol(apiProtocol), [self.versionUsed stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
        
        NSLog(@"Using class name %@", className);
        
        Class clazz = NSClassFromString(className);
        self.implementingObject = [[[clazz alloc] init] autorelease];        
    }
    if ([self.implementingObject respondsToSelector:aSelector]) {
        return [self.implementingObject methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.implementingObject respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.implementingObject];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@synthesize apiProtocol;
@synthesize implementingObject;
@synthesize versionUsed;

@end