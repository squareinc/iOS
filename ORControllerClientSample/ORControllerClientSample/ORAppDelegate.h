//
//  ORAppDelegate.h
//  ORControllerClientSample
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORViewController;

@interface ORAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ORViewController *viewController;

@end
