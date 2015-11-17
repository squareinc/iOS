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

/*
 * This is the entrypoint of the application.
 *  After application have been started applicationDidFinishLaunching method will be called.
 */

#import "AppDelegate.h"
#import "NotificationConstant.h"
#import "DirectoryDefinition.h"
#import "ORConsoleSettingsManager.h"
#import "ImageCache.h"
#import "ViewHelper.h"
#import "DefinitionManager.h"

#define STARTUP_UPDATE_TIMEOUT 10

@interface AppDelegate ()

- (void)didUpdate;
- (void)didUseLocalCache:(NSString *)errorMessage;
- (void)didUpdateFail:(NSString *)errorMessage;

@property (nonatomic, strong) ImageCache *imageCache;
@property (nonatomic, strong) DefinitionManager *definitionManager;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    ORConsoleSettingsManager *settingsManager = [[ORConsoleSettingsManager alloc] init];
    
    self.definitionManager = [[DefinitionManager alloc] init];

    self.defaultViewController = [[DefaultViewController alloc] initWithSettingsManager:settingsManager definitionManager:self.definitionManager delegate:self];

	// Default window for the app
	window = [[GestureWindow alloc] init];
	[window makeKeyAndVisible];
	
    window.rootViewController = self.defaultViewController;
	
	//Init UpdateController and set delegate to this class, it have three delegate methods
    // - (void)didUpdate;
    // - (void)didUseLocalCache:(NSString *)errorMessage;
    // - (void)didUpdateFail:(NSString *)errorMessage;
    updateController = [[UpdateController alloc] initWithSettings:settingsManager.consoleSettings definitionManager:self.definitionManager delegate:self];

    [updateController startup];
    
    // settings manager is not retained by this class, objects using it must have a strong reference to it
}

// when it's launched by other apps.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self applicationDidFinishLaunching:application];
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.defaultViewController connectToController];
    
    // TODO: review
	[self.defaultViewController refreshPolling];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.defaultViewController disconnectFromController];
    

    // Persist current definition to a cache file
    [self.definitionManager saveDefinitionToCache];
}




- (void)checkConfigAndUpdate {
	[updateController checkConfigAndUpdateUsingTimeout:STARTUP_UPDATE_TIMEOUT];
}

// this method will be called after UpdateController give a callback.
- (void)updateDidFinish {
	log4Info(@"----------updateDidFinished------");
    NSLog(@"Is App Launching %d", ([self.defaultViewController isAppLaunching]));

	if ([self.defaultViewController isAppLaunching]) {//blocked from app launching, should refresh all groups.
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLoading object:nil];
        
        // EBR : this is what makes the UI display in the first place
        
		[self.defaultViewController initGroups];
	} else {//blocked from sending command, should refresh command.
		[self.defaultViewController refreshPolling];
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideLoading object:nil];
}

#pragma mark delegate method of updateController

- (void)didUpdate {
    log4Info(@">>AppDelegate.didUpdate");
	[self updateDidFinish];
}

- (void)didUseLocalCache:(NSString *)errorMessage {
	if ([errorMessage isEqualToString:@"401"]) {
		[self.defaultViewController populateLoginView:nil];
	} else {
        ViewHelper *viewHelper = [[ViewHelper alloc] init];
		[viewHelper showAlertViewWithTitleAndSettingNavigation:@"Warning" Message:[errorMessage stringByAppendingString:@" Using cached content."]];
		[self updateDidFinish];
	}
	
}

- (void)didUpdateFail:(NSString *)errorMessage {
	log4Error(@"%@", errorMessage);
	if ([errorMessage isEqualToString:@"401"]) {
		[self.defaultViewController populateLoginView:nil];
	} else {
        ViewHelper *viewHelper = [[ViewHelper alloc] init];
		[viewHelper showAlertViewWithTitleAndSettingNavigation:@"Update Failed" Message:errorMessage];		
		[self updateDidFinish];
	}
}

@synthesize defaultViewController;

- (void)replaceDefaultViewController:(DefaultViewController *)newDefaultViewController {
    self.defaultViewController = newDefaultViewController;
    window.rootViewController = newDefaultViewController;
}


@end