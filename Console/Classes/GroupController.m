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
#import "GroupController.h"
#import "NotificationConstant.h"
#import "PaginationController.h"
#import "ORControllerClient/ORScreen.h"
#import "ScreenViewController.h"
#import "UIScreen+ORAdditions.h"
#import "UIImage+ORAdditions.h"
#import "ORControllerConfig.h"
#import "ORControllerClient/Definition.h"

@interface GroupController ()

- (NSArray *)viewControllersForScreens:(NSArray *)screens;
- (void)showErrorView;
- (void)fixGeometryForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@property (weak) PaginationController *currentPaginationController;
@property (weak) UIViewController *parentViewController;

@property (strong) UIView *maskView;

@end

@implementation GroupController

- (id)initWithGroup:(ORGroup *)newGroup parentViewController:(UIViewController *)aVC
{
    self = [super init];
	if (self) {
		self.group = newGroup;
        self.parentViewController = aVC;
	}
	return self;
}

- (void)dealloc
{
    self.parentViewController = nil;
    self.imageCache = nil;
}

- (void)debugLogGeometry
{
    NSLog(@"========================================");
    NSLog(@"view hierarchy %@ %@ %@ %@", self.view, self.view.superview, self.view.superview.superview, self.view.superview.superview);
    OR_LogAffineTransform(@"View transform", self.view.transform);
    OR_LogPoint(@"View center", self.view.center);
    OR_LogRect(@"View bounds", self.view.bounds);
    OR_LogRect(@"View frame", self.view.frame);
    OR_LogAffineTransform(@"Superview transform", self.view.superview.transform);
    OR_LogPoint(@"Superview center", self.view.superview.center);
    OR_LogRect(@"Superview bounds", self.view.superview.bounds);
    OR_LogRect(@"Superview frame", self.view.superview.frame);
    OR_LogAffineTransform(@"Window transform", self.view.window.transform);
    OR_LogPoint(@"Window center", self.view.window.center);
    OR_LogRect(@"Window bounds", self.view.window.bounds);
    OR_LogRect(@"Window frame", self.view.window.frame);
    NSLog(@"========================================");
}


- (CGRect)getFullFrame
{
    return [UIScreen or_fullFrameForInterfaceOrientation:self.parentViewController.interfaceOrientation];
}

- (ORObjectIdentifier *)groupIdentifier
{
	return self.group.identifier;
}

// Returns an array of ScreenViewControllers for the given Screen objects
- (NSArray *)viewControllersForScreens:(NSArray *)screens {
	NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:[screens count]];
	
	for (ORScreen *screen in screens) {
		NSLog(@"init screen = %@", screen.name);
		ScreenViewController *viewController = [[ScreenViewController alloc] init];
        viewController.imageCache = self.imageCache;
		[viewController setScreen:screen];
		[viewControllers addObject:viewController];
	}
	return [NSArray arrayWithArray:viewControllers];
}

// Show the view of specified orientation depending on the parameter isLandScape specified.
- (void)showLandscapeOrientation:(BOOL)isLandscape {
	
	NSArray *screens = isLandscape ? [self.group landscapeScreens] : [self.group portraitScreens];

	if (screens.count == 0) {
        // Check if other orientation has screens
        isLandscape = !isLandscape;
        screens = isLandscape ? [self.group landscapeScreens] : [self.group portraitScreens];
        if ([screens count] == 0) {
            // Still no luck, error
            [self showErrorView];
            return;
        }
	}
	
	if (isLandscape) {
		if (landscapePaginationController == nil) {
			landscapePaginationController = [[PaginationController alloc] initWithGroup:self.group
                                                                                 tabBar:self.group.definition.tabBar];
            landscapePaginationController.imageCache = self.imageCache;
			[landscapePaginationController setViewControllers:[self viewControllersForScreens:screens] isLandscape:isLandscape];
		}
        self.currentPaginationController = landscapePaginationController;
        
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // Resize view to fill screen in appropriate orientation
        CGRect b = [UIScreen mainScreen].bounds;
        self.view.frame = CGRectMake(0.0, 0.0, MAX(b.size.width, b.size.height), MIN(b.size.width, b.size.height));
        [self.view addSubview:landscapePaginationController.view];


        // By setting view above, on 1st time, view bounds got reset to "portrait". Force it back to "landscape"
        self.view.bounds = [UIScreen or_fullFrameForInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        
		[[portraitPaginationController currentScreenViewController] stopPolling];
		[[landscapePaginationController currentScreenViewController] startPolling];
	} else {
		if (portraitPaginationController == nil) {
			portraitPaginationController = [[PaginationController alloc] initWithGroup:self.group
                                                                                tabBar:self.group.definition.tabBar];
            portraitPaginationController.imageCache = self.imageCache;
			[portraitPaginationController setViewControllers:[self viewControllersForScreens:screens] isLandscape:isLandscape];
		}
        self.currentPaginationController = portraitPaginationController;
        
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // Resize view to fill screen in appropriate orientation
        CGRect b = [UIScreen mainScreen].bounds;
        self.view.frame = CGRectMake(0.0, 0.0, MIN(b.size.width, b.size.height), MAX(b.size.width, b.size.height));
        [self.view addSubview:portraitPaginationController.view];
        
		[[landscapePaginationController currentScreenViewController] stopPolling];
		[[portraitPaginationController currentScreenViewController] startPolling];
	}
}

// Show portrait orientation view.
- (void)showPortrait {
	NSLog(@"show portrait");
	[self showLandscapeOrientation:NO];
}

// Show landscape orientation view.
- (void)showLandscape {
	NSLog(@"show landscape");
	[self showLandscapeOrientation:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[self.navigationController setNavigationBarHidden:YES];

    if (UIInterfaceOrientationIsLandscape(self.parentViewController.interfaceOrientation)) {
		NSLog(@"view did load show landscape");
		[self showLandscape];
    } else {
		NSLog(@"view did load show portrait");
		[self showPortrait];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fixGeometryForInterfaceOrientation:self.parentViewController.interfaceOrientation];
}

- (void)viewDidUnload
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [super viewDidUnload];
}

// Show error view if some error occured.
- (void)showErrorView {
	errorViewController = [[ErrorViewController alloc] initWithErrorTitle:@"No Screen Found" message:@"Please associate screens with this group of this orientation."];
	[errorViewController.view setFrame:[self getFullFrame]];
	[self setView:errorViewController.view];	
}

- (ScreenViewController *)currentScreenViewController {
	return [[self currentPaginationController] currentScreenViewController]; 
}

- (ORScreen *)currentScreen {
	return [self currentScreenViewController].screen;
}

- (ORObjectIdentifier *)currentScreenIdentifier {
	return [self currentScreen].identifier;
}

- (void)startPolling {
	if ([self currentPaginationController].viewControllers.count > 0) {
		[[self currentScreenViewController] startPolling];
		NSLog(@"start polling screen_id = %@", [self currentScreenIdentifier]);
	}
}

- (void)stopPolling {
	for (ScreenViewController *svc in [self currentPaginationController].viewControllers) {
		NSLog(@"stop polling screen_id = %@", svc.screen.identifier);
		[svc stopPolling];
	}
}

- (BOOL)switchToScreen:(ORScreen *)aScreen {
	NSLog(@"switch to screen %@", aScreen.identifier);
	return [[self currentPaginationController] switchToScreen:aScreen];
}

- (BOOL)previousScreen {
	return [[self currentPaginationController] previousScreen];
}

- (BOOL)nextScreen {
	return [[self currentPaginationController] nextScreen];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (errorViewController.view == self.view) {
		return YES;
	}
    return NO;
}

- (void)fixGeometryForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGAffineTransform myTransform = CGAffineTransformIdentity;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            if ([self currentScreen].orientation == ORScreenOrientationLandscape) myTransform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if ([self currentScreen].orientation == ORScreenOrientationLandscape) myTransform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if ([self currentScreen].orientation == ORScreenOrientationPortrait) myTransform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            if ([self currentScreen].orientation == ORScreenOrientationPortrait) myTransform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        default:
            break;
    }
    
    self.view.transform = myTransform;
    self.view.bounds = [UIScreen or_fullFrameForLandscapeOrientation:([self currentScreen].orientation == ORScreenOrientationLandscape)];
    self.view.center = UIInterfaceOrientationIsPortrait(interfaceOrientation)?self.view.superview.center:CGPointMake(self.view.superview.center.y, self.view.superview.center.x);    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIImageView *tmpView = [[UIImageView alloc] initWithImage:[UIImage or_screenshotForWindow:self.view.window]];
    if (self.maskView) {
        [self.maskView removeFromSuperview];
    }
    self.maskView = tmpView;
    [self.view.window addSubview:self.maskView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(self.parentViewController.interfaceOrientation)) {
        if ([self currentScreen].orientation == ORScreenOrientationPortrait) {
            // Going to a landscape version and not currently showing a landscape screen
            ORScreen *landscapeScreen = [self currentScreen].rotatedScreen;
            // If there is a landscape version of the screen, install that one
            if (landscapeScreen) {
                [self showLandscape];
                [[self currentPaginationController] switchToScreen:landscapeScreen];
            }
        }        
    } else {
        if ([self currentScreen].orientation == ORScreenOrientationLandscape) {
            // Going to portrait and not currently showing a portrait screen
            ORScreen *portraitScreen = [self currentScreen].rotatedScreen;
            if (portraitScreen) {
                // If there is a portrait version of the screen, install that one
                [self showPortrait];
                [[self currentPaginationController] switchToScreen:portraitScreen];
            }
        }
    }
    [self fixGeometryForInterfaceOrientation:self.parentViewController.interfaceOrientation];
    [self.maskView removeFromSuperview];
}

@synthesize group;
@synthesize currentPaginationController;
@synthesize parentViewController;
@synthesize maskView;

@end