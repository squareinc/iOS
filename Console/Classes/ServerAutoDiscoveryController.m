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
#import "ServerAutoDiscoveryController.h"
#import "AppSettingsDefinition.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

#import "ORControllerClient/ORControllerBrowser.h"
#import "ORControllerClient/ORControllerInfo.h"
#import "ORControllerClient/ORControllerAddress.h"

@interface ServerAutoDiscoveryController () <ORControllerBrowserDelegate>

@property (nonatomic, weak) ORConsoleSettings *settings;

@property (nonatomic, strong) ORControllerBrowser *browser;

@end

@implementation ServerAutoDiscoveryController

// Setup autodiscovery and start.
- (id)initWithConsoleSettings:(ORConsoleSettings *)theSettings delegate:(id <ServerAutoDiscoveryControllerDelagate>)aDelegate
{
    self = [super init];
	if (self) {
        self.settings = theSettings;
        self.delegate = aDelegate;
        
        self.browser = [[ORControllerBrowser alloc] init];
        self.browser.delegate = self;
        [self.browser startSearchingForORControllers];
	}
	return self;
}

- (void)dealloc
{
    [self.browser stopSearchingForORControllers];
    
    self.browser = nil;
    self.settings = nil;
}

- (void)controllerBrowser:(ORControllerBrowser *)browser didFindController:(ORControllerInfo *)controllerInfo
{
    [self controllerDiscovered:controllerInfo];
}

- (void)controllerBrowser:(ORControllerBrowser *)browser didUpdateController:(ORControllerInfo *)controllerInfo
{
    [self controllerDiscovered:controllerInfo];
}

- (void)controllerBrowser:(ORControllerBrowser *)browser didFail:(NSError *)error
{
    NSLog(@"Auto-discovery failed with error %@", error.description);
    if (self.delegate && [self.delegate respondsToSelector:@selector(onFindServerFail:)]) {
		[self.delegate performSelector:@selector(onFindServerFail:) withObject:@"Auto-discovery error"];
	}
}

- (void)controllerDiscovered:(ORControllerInfo *)controllerInfo
{
    NSString *serverUrl = [controllerInfo.address.primaryURL description];
    
    // Only add the server (and report) if not yet known
    for (ORControllerConfig *controller in self.settings.controllers) {
        if ([controller.primaryURL isEqualToString:serverUrl]) {
            return;
        }
    }
    
    ORControllerConfig *controller = [self.settings addControllerForURL:serverUrl];
    
	// Call the delegate method delegate implemented
	if (self.delegate && [self.delegate respondsToSelector:@selector(onFindServer:)]) {
        [self.delegate onFindServer:controller];
	}
}

@synthesize delegate;

@end