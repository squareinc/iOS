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
#import "DefaultViewController.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORNavigation.h"
#import "ORControllerClient/ORScreenNavigation.h"
#import "ORControllerClient/ORGroup.h"
#import "ORControllerClient/ORScreen.h"
#import "ORControllerClient/ORObjectIdentifier.h"
#import "ORControllerClient/ORController.h"

#import "NavigationManager.h"
#import "ORScreenOrGroupReference.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface DefaultViewController ()

@property (nonatomic, strong) GroupController *currentGroupController;

@property (nonatomic, weak) NSObject <DefaultViewControllerDelegate> *_delegate;

@property (nonatomic, strong) ORConsoleSettingsManager *settingsManager;

@property (nonatomic, strong) Definition *_definition;

@property (nonatomic, strong) NavigationManager *navigationManager;

@property (nonatomic, weak) DefinitionManager *definitionManager;

@end

@interface DefaultViewController (Private)

- (void)navigateFromNotification:(NSNotification *)notification;
- (void)refreshView:(id)sender;
- (BOOL)navigateToGroup:(ORGroup *)aGroup toScreen:(ORScreen *)aScreen;
- (void)logout;
- (void)navigateTo:(ORNavigation *)navi;
- (void)rerenderTabbarWithNewOrientation;
- (void)transformToOppositeOrientation;

@end

@implementation DefaultViewController

- (id)initWithSettingsManager:(ORConsoleSettingsManager *)aSettingsManager definitionManager:(DefinitionManager *)aDefinitionManager delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.settingsManager = aSettingsManager;
        self.definitionManager = aDefinitionManager;
        
			self._delegate = delegate;
			
			//register notifications
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateFromNotification:) name:NotificationNavigateTo object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateSettingsView:) name:NotificationPopulateSettingsView object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:NotificationRefreshGroupsView object:nil];	
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateLoginView:) name:NotificationPopulateCredentialView object:nil];

    // EBR: is this required, already set in Info.plist
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationPopulateCredentialView object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [super viewDidDisappear:animated];
}

- (void)loadView
{
	[super loadView];
	[self.view setBackgroundColor:[UIColor blackColor]];

	//Init the error view with xib
	errorViewController = [[ErrorViewController alloc] initWithErrorTitle:@"No Group Found" message:@"Please check your setting or define a group with screens first."];
    [self presentErrorViewController];
	
	//Init the loading view with xib
	initViewController = [[InitViewController alloc] init];
    [self presentInitViewController];
}

- (void)refreshPolling
{
	[self.currentGroupController startPolling];
}

- (void)setDefinition:(Definition *)definition
{
    
    // TODO: handle fact that definition instance does not change, should not trigger everything
    // but still, definition "content" could have changed -> must validate current group / screen
    self._definition = definition;

    self.navigationManager = [[NavigationManager alloc] initWithDefinition:definition];
    
    ORScreenOrGroupReference *screenReference = [self.navigationManager currentScreenReference];
    
    // Navigation manager ensures that referenced group / screen exists if it returns a screen reference
    if (screenReference) {
        ORGroup *currentGroup = [definition findGroupByIdentifier:screenReference.groupIdentifier];
        
        GroupController *gc = [[GroupController alloc] initWithGroup:currentGroup parentViewController:self];
        gc.imageCache = self.imageCache;
        [self switchToGroupController:gc];
    } else {
        // Means no group with screen does exist
        [self presentErrorViewController];
    }
}

- (void)initGroups {
    [self hideErrorViewController];
    [self hideInitViewController];
	
    [self setDefinition:[self.settingsManager consoleSettings].selectedController.definition];
}

- (void)navigateFromNotification:(NSNotification *)notification {
	if (notification) {
		ORNavigation *navi = (ORNavigation *)[notification object];
		[self navigateTo:navi];
	}
}

- (void)navigateTo:(ORNavigation *)navi
{
    // TODO EBR : Why this test ?
	if (!self.currentGroupController.group) {
        return;
    }

    ORScreenOrGroupReference *destination = nil;

    switch (navi.navigationType) {
        case ORNavigationTypeToGroupOrScreen:
        {
            ORScreenNavigation *screenNavi = (ORScreenNavigation *)navi;
            destination = [self.navigationManager navigateToGroup:screenNavi.destinationGroup toScreen:screenNavi.destinationScreen];
            break;
        }
        case ORNavigationTypePreviousScreen:
        {
            destination = [self.navigationManager navigateToPreviousScreen];
            break;
        }
        case ORNavigationTypeNextScreen:
        {
            destination = [self.navigationManager navigateToNextScreen];
            break;
        }
        case ORNavigationTypeBack:
        {
            destination = [self.navigationManager back];
            break;
        }
        case ORNavigationTypeLogin:
            [self populateLoginView:nil];
            return;
        case ORNavigationTypeLogout:
            [self logout];
            return;
        case ORNavigationTypeSettings:
            [self populateSettingsView:nil];
            return;
        default:
            return;
    }
    
    // Navigate based on destination, being assured that if not nil, it exists
    if (destination) {
        [self navigateToGroup:[self._definition findGroupByIdentifier:destination.groupIdentifier]
                     toScreen:[self._definition findScreenByIdentifier:destination.screenIdentifier]];
    }
}

- (void)updateGlobalOrLocalTabbarViewToGroupController:(GroupController *)targetGroupController
{
	[self hideErrorViewController];
    [self hideInitViewController];
    [self switchToGroupController:targetGroupController];
}

- (BOOL)navigateToGroup:(ORGroup *)group toScreen:(ORScreen *)screen
{
    // Going to another group
	if (![group.identifier isEqual:[self.currentGroupController groupIdentifier]]) {
		GroupController *targetGroupController = [[GroupController alloc] initWithGroup:group parentViewController:self];
        targetGroupController.imageCache = self.imageCache;
		
        [self.currentGroupController stopPolling];
		[self updateGlobalOrLocalTabbarViewToGroupController:targetGroupController];
	}
	
    // TODO: is next line really required ? Or should group controller / pagination controller take care of that ?
    ORScreen *targetScreen = [screen screenForOrientation:UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])?ORScreenOrientationLandscape:ORScreenOrientationPortrait];
	return [self.currentGroupController switchToScreen:targetScreen];
}

//logout only when password is saved.
- (void)logout {
	if (self.settingsManager.consoleSettings.selectedController.password) {
		LogoutHelper *logout = [[LogoutHelper alloc] init];
		[logout requestLogout];
	}	
}

// Version used by newer code using client library and authentication manager mechanism

- (void)presentLoginViewWithDelegate:(id <LoginViewControllerDelegate>)delegate
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithController:self.settingsManager.consoleSettings.selectedController
                                                                                  delegate:delegate
                                                                                   context:NULL];
	UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    // If we are already presenting a VC (e.g. Settings), this one must present the login panel
	[((self.presentedViewController)?self.presentedViewController:self) presentViewController:loginNavController animated:YES completion:NULL];
}

// Version used by legacy code, to eventually go away

//prompts the user to enter a valid user name and password
- (void)populateLoginView:(NSNotification *)notification {
	LoginViewController *loginController = [[LoginViewController alloc] initWithController:self.settingsManager.consoleSettings.selectedController
                                                                                  delegate:self
                                                                                   context:[notification.userInfo objectForKey:kAuthenticationRequiredControllerRequest]];
	UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
	[self presentViewController:loginNavController animated:NO completion:nil];
}

- (void)populateSettingsView:(id)sender {
	AppSettingController *settingController = [[AppSettingController alloc] initWithSettingsManager:self.settingsManager definitionManager:self.definitionManager];
    settingController.imageCache = self.imageCache;
	UINavigationController *settingNavController = [[UINavigationController alloc] initWithRootViewController:settingController];
	[self presentViewController:settingNavController animated:YES completion:nil];
}

- (void)refreshView:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLoading object:nil];

	if (self.currentGroupController) {
		[self.currentGroupController stopPolling];
//        self.currentGroupController = nil;
	}
	
	[self initGroups];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideLoading object:nil];
}

- (BOOL)isAppLaunching {
	return ![self isLoadingViewGone];
}

- (BOOL)isLoadingViewGone {
	return self.currentGroupController != nil;
}

#pragma mark delegate method of LoginViewController

- (void)loginViewControllerDidCancelLogin:(LoginViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];

	[self._delegate updateDidFinish];
}

- (void)loginViewController:(LoginViewController *)controller didProvideUserName:(NSString *)username password:(NSString *)password
{
    ORControllerConfig *orController = ((ControllerRequest *)controller.context).controller;
    if (!orController) {
        orController = self.settingsManager.consoleSettings.selectedController;
    }
    orController.userName = username;
	orController.password = password;
    
    // TODO: we might not want to save here, maybe have a method to set this and save in dedicated MOC
    [self.settingsManager saveConsoleSettings];
    
	[self dismissViewControllerAnimated:YES completion:nil];
    
	[self.currentGroupController stopPolling];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLoading object:nil];
	[self._delegate checkConfigAndUpdate];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideLoading object:nil];    
}

#pragma mark Rotation handling

- (BOOL)shouldAutorotate
{
    // delegate rotation to the group controller
    return [self.currentGroupController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.currentGroupController supportedInterfaceOrientations];
}


// Because this VC is installed at root, it needs to forward those messages to the VC it contains
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (![self isLoadingViewGone]) {
		[initViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (![self isLoadingViewGone]) {
        [initViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}








- (void)presentGroupController:(GroupController *)groupController animated:(BOOL)flag
{
    // At this stage, no animation support
    
    [self switchToGroupController:groupController];
}






#pragma mark Child view controller management

- (void)presentErrorViewController
{
    [self addChildViewController:errorViewController];
    errorViewController.view.frame = self.view.bounds;
    [self.view addSubview:errorViewController.view];
    [errorViewController didMoveToParentViewController:self];
}

- (void)hideErrorViewController
{
    [errorViewController willMoveToParentViewController:nil];
    [errorViewController.view removeFromSuperview];
    [errorViewController removeFromParentViewController];
}

- (void)presentInitViewController
{
    [self addChildViewController:initViewController];
    initViewController.view.frame = self.view.bounds;
    [self.view addSubview:initViewController.view];
    [initViewController didMoveToParentViewController:self];
}

- (void)hideInitViewController
{
    [initViewController willMoveToParentViewController:nil];
    [initViewController.view removeFromSuperview];
    [initViewController removeFromParentViewController];
}

- (void)switchToGroupController:(GroupController *)gc
{
    if (self.currentGroupController) {
        [self.currentGroupController willMoveToParentViewController:nil];
        [self.currentGroupController.view removeFromSuperview];
        [self.currentGroupController removeFromParentViewController];
    }
    self.currentGroupController = gc;
    if (gc) {
        [self addChildViewController:gc];
        [self.view addSubview:gc.view];
        [gc didMoveToParentViewController:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)connectToController
{
    [[self.settingsManager consoleSettings].selectedController.controller connectWithSuccessHandler:NULL errorHandler:NULL];
}

- (void)disconnectFromController
{
    [[self.settingsManager consoleSettings].selectedController.controller disconnect];
}

#pragma mark Status bar management

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Detect the shake motion.

-(BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    if ([self isLoadingViewGone]) {
		[self.currentGroupController viewDidAppear:animated];
    }
    
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake && [self isLoadingViewGone]) {
		[self populateSettingsView:nil];
	}
}

@end