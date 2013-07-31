//
//  PanelLayoutResponseHandler_2_0_0.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORDataCapturingNSURLConnectionDelegate.h"

@class Definition;

@interface PanelLayoutResponseHandler_2_0_0 : NSObject <ORDataCapturingNSURLConnectionDelegateDelegate>

// TODO: doc
- (id)initWithSuccessHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

@end
