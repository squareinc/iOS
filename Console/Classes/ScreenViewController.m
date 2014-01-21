/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#import "ScreenViewController.h"
#import "ViewHelper.h"
#import "ORControllerClient/Definition.h"
#import "NotificationConstant.h"
#import "ServerDefinition.h"
#import "CredentialUtil.h"
#import "ControllerException.h"
#import "ORControllerConfig.h"
#import "ORControllerProxy.h"
#import "ScreenSubController.h"
#import "PollingHelper.h"

@interface ScreenViewController ()

- (void)sendCommandRequest:(Component *)component;
- (void)doNavigate:(Navigate *)navi;

@property (nonatomic, strong) ScreenSubController *screenSubController;
@property (nonatomic, weak) ORControllerConfig *controller;
@property (nonatomic, strong) PollingHelper *polling;

@property (nonatomic, strong) NSMutableArray *gestureRecognizers;

@end

@implementation ScreenViewController

- (id)initWithController:(ORControllerConfig *)aController
{
    self = [super init];
    if (self) {
        self.controller = aController;
        self.gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

- (void)dealoc
{
    [self cleanupGestureRecognizers];
    [self stopPolling];
    self.polling = nil;
	self.screenSubController = nil;
    self.controller = nil;
    self.imageCache = nil;
    self.screen = nil;
}

// Implement loadView to create a view hierarchy programmatically.
- (void)loadView
{
    self.screenSubController = [[ScreenSubController alloc] initWithController:self.controller imageCache:self.imageCache screen:self.screen];
    self.view = self.screenSubController.view;    
}

- (void)viewDidUnload
{
    self.screenSubController = nil;
    self.view = nil;
    [super viewDidUnload];
}

- (void)startPolling
{
	[self.polling requestCurrentStatusAndStartPolling];
}
- (void)stopPolling
{
	[self.polling cancelPolling];
}

// Send control command for gesture actions.
- (void)sendCommandRequest:(Component *)component
{
    [self.controller.proxy sendCommand:@"swipe" forComponent:component delegate:nil];
}

- (void)doNavigate:(Navigate *)navi
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationNavigateTo object:navi];
}

#pragma mark - Gesture Recognizers handling

- (void)setupGestureRecognizers
{
    [self cleanupGestureRecognizers];

    // If there are gestures, this view must allow interaction with it
    self.view.userInteractionEnabled = ([self.screen.gestures count] > 0);

    for (Gesture *gesture in self.screen.gestures) {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        recognizer.direction = [self convertSwipeTypeToGestureRecognizerDirection:gesture.swipeType];
        
        recognizer.numberOfTouchesRequired = 1;
        
        [self.view addGestureRecognizer:recognizer];
        [self.gestureRecognizers addObject:recognizer];
    }
}

- (void)cleanupGestureRecognizers
{
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.view removeGestureRecognizer:obj];
    }];
    [self.gestureRecognizers removeAllObjects];
}

- (UISwipeGestureRecognizerDirection)convertSwipeTypeToGestureRecognizerDirection:(GestureSwipeType)swipeType
{
    if (swipeType == GestureSwipeTypeBottomToTop) {
        return UISwipeGestureRecognizerDirectionUp;
    } else if (swipeType == GestureSwipeTypeTopToBottom) {
        return UISwipeGestureRecognizerDirectionDown;
    } else if (swipeType == GestureSwipeTypeLeftToRight) {
        return UISwipeGestureRecognizerDirectionRight;
    } else if (swipeType == GestureSwipeTypeRightToLeft) {
        return UISwipeGestureRecognizerDirectionLeft;
    }
    return NSNotFound;
}

- (GestureSwipeType)convertGestureRecognizerDirectionToSwipeType:(UISwipeGestureRecognizerDirection)direction
{
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        return GestureSwipeTypeBottomToTop;
    } else if (direction == UISwipeGestureRecognizerDirectionDown) {
        return GestureSwipeTypeTopToBottom;
    } else if (direction == UISwipeGestureRecognizerDirectionRight) {
        return GestureSwipeTypeLeftToRight;
    } else {
        return GestureSwipeTypeRightToLeft;
    }
}

#pragma mark - Gesture Recognizers action

- (void)handleGesture:(UISwipeGestureRecognizer *)recognizer
{
	Gesture * g = [self.screen getGestureIdByGestureSwipeType:[self convertGestureRecognizerDirectionToSwipeType:recognizer.direction]];
	if (g) {
		if (g.hasControlCommand) {
			[self sendCommandRequest:g];
		} else if (g.navigate) {
			[self doNavigate:g.navigate];
		}
	}
}

#pragma mark ORControllerCommandSenderDelegate implementation

- (void)commandSendFailed
{
}

@synthesize screen;
@synthesize polling;
@synthesize screenSubController;

/**
 * Assign parameter screen model data to screenViewController.
 */
- (void)setScreen:(Screen *)s {
	screen = s;
    [self setupGestureRecognizers];
	if ([[screen pollingComponentsIds] count] > 0 ) {
		self.polling = [[PollingHelper alloc] initWithController:self.controller
                                                    componentIds:[[screen pollingComponentsIds] componentsJoinedByString:@","]];
        self.polling.imageCache = self.imageCache;
	}
}

@end
