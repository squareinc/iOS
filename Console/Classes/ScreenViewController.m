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
#import "ORControllerClient/ORNavigation.h"
#import "ORControllerClient/ORGesture.h"
#import "NotificationConstant.h"
#import "ServerDefinition.h"
#import "CredentialUtil.h"
#import "ControllerException.h"
#import "ORControllerConfig.h"
#import "ORControllerProxy.h"
#import "ORUISlider.h"
#import "ScreenSubController.h"

@interface ScreenViewController ()

@property (nonatomic, strong) ScreenSubController *screenSubController;
@property (nonatomic, weak) ORControllerConfig *controller;

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
	self.screenSubController = nil;
    self.controller = nil;
    self.imageCache = nil;
    self.screen = nil;
}

// Implement loadView to create a view hierarchy programmatically.
- (void)loadView
{
    self.screenSubController = [[ScreenSubController alloc] initWithImageCache:self.imageCache screen:self.screen];
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
    // TODO: check if anything required here
}

- (void)stopPolling
{
    // TODO: check if anything required here
}

#pragma mark - Gesture Recognizers handling

- (void)setupGestureRecognizers
{
    [self cleanupGestureRecognizers];

    for (ORGesture *gesture in self.screen.gestures) {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        recognizer.direction = [self convertGestureTypeToGestureRecognizerDirection:gesture.gestureType];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.delegate = self;
        
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

- (UISwipeGestureRecognizerDirection)convertGestureTypeToGestureRecognizerDirection:(ORGestureType)gestureType
{
    switch (gestureType) {
        case ORGestureTypeSwipeBottomToTop:
            return UISwipeGestureRecognizerDirectionUp;
        case ORGestureTypeSwipeTopToBottom:
            return UISwipeGestureRecognizerDirectionDown;
        case ORGestureTypeSwipeLeftToRight:
            return UISwipeGestureRecognizerDirectionRight;
        case ORGestureTypeSwipeRightToLeft:
            return UISwipeGestureRecognizerDirectionLeft;
        default:
            return NSNotFound;
    }
    return NSNotFound;
}

- (ORGestureType)convertGestureRecognizerDirectionToGestureType:(UISwipeGestureRecognizerDirection)direction
{
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        return ORGestureTypeSwipeBottomToTop;
    } else if (direction == UISwipeGestureRecognizerDirectionDown) {
        return ORGestureTypeSwipeTopToBottom;
    } else if (direction == UISwipeGestureRecognizerDirectionRight) {
        return ORGestureTypeSwipeLeftToRight;
    } else {
        return ORGestureTypeSwipeRightToLeft;
    }
}

#pragma mark - Gesture Recognizers delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // This makes sure that any swipe gesture do not interfere with sliders operation
    if ([touch.view.superview isKindOfClass:[ORUISlider class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Gesture Recognizers action

- (void)handleGesture:(UISwipeGestureRecognizer *)recognizer
{
	ORGesture * g = [self.screen gestureForType:[self convertGestureRecognizerDirectionToGestureType:recognizer.direction]];
	if (g) {
        [g perform];
	}
}

@synthesize screen;
@synthesize screenSubController;

// TODO: don't re-implement setter but use KVO + setter is not implementing memory management correctly
// TODO: seems screen property can just be read-only and screen is set in init -> simplifies code
/**
 * Assign parameter screen model data to screenViewController.
 */
- (void)setScreen:(ORScreen *)s
{
	screen = s;
    [self setupGestureRecognizers];
    /*
     
     // TODO: review, PollingHelper is not used for remote sensors anyway
     // see what needs to be done to handle local sensors
     
	if ([[screen pollingComponentsIds] count] > 0 ) {
		self.polling = [[PollingHelper alloc] initWithController:self.controller
                                                    componentIds:[[screen pollingComponentsIds] componentsJoinedByString:@","]];
        self.polling.imageCache = self.imageCache;
	}
     */
}

@end