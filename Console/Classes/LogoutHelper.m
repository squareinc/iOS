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
#import "LogoutHelper.h"
#import "ServerDefinition.h"
#import "ViewHelper.h"
#import "ViewHelper.h"
#import "ControllerException.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

@interface LogoutHelper ()

@property (nonatomic, assign) ORConsoleSettingsManager *settingsManager;
@end


@implementation LogoutHelper

- (id)initWithConsoleSettingsManager:(ORConsoleSettingsManager *)aSettingsManager
{
    self = [super init];
    if (self) {
        self.settingsManager = aSettingsManager;
    }
    return self;
}

- (void)dealloc
{
    self.settingsManager = nil;
    [super dealloc];
}

- (void)requestLogout {
	NSURL *url = [[NSURL alloc] initWithString:[ServerDefinition logoutUrlForController:self.settingsManager.consoleSettings.selectedController]];
	
	//assemble put request 
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];

	URLConnectionHelper *connection = [[URLConnectionHelper alloc] initWithRequest:request delegate:self];
	
    // TODO: validate how this should be implemented, creating a connection here, not retained by anycode might be trouble
    
	[url release];
	[request release];
}

// Handle the server response which are from controller server with status code.
- (void)handleServerResponseWithStatusCode:(int) statusCode {
	if (statusCode != 200) {
		switch (statusCode) {
			case UNAUTHORIZED://logout succuessful
            {
                ORControllerConfig *activeController = self.settingsManager.consoleSettings.selectedController;
				NSLog(@"%@ logged out successfully", activeController.userName);
				[ViewHelper showAlertViewWithTitle:@"" Message:[NSString stringWithFormat:@"%@ logged out successfully", activeController.userName]];
                activeController.password = nil;
                [self.settingsManager saveConsoleSettings];
				return;
            }
		} 		
		[ViewHelper showAlertViewWithTitle:@"Send Request Error" Message:[ControllerException controller:self.settingsManager.consoleSettings.selectedController
                                                                                  exceptionMessageOfCode:statusCode]];
	} 
	
}


#pragma mark delegate method of NSURLConnection
- (void) definitionURLConnectionDidFailWithError:(NSError *)error {

}


- (void)definitionURLConnectionDidFinishLoading:(NSData *)data {
	
}

- (void)definitionURLConnectionDidReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
	[self handleServerResponseWithStatusCode:[httpResp statusCode]];
}


@end
