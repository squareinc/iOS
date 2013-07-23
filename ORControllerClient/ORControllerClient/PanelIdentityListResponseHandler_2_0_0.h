//
//  PanelIdentityListResponseHandler_2_0_0.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 23/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORDataCapturingNSURLConnectionDelegate.h"

@interface PanelIdentityListResponseHandler_2_0_0 : NSObject <ORDataCapturingNSURLConnectionDelegateDelegate>

// TODO: doc
- (id)initWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

@end
