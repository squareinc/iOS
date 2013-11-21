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
#import "ORControllerPanelsFetcher.h"
#import "ServerDefinition.h"
#import "ORControllerClient/Definition.h"
#import "ViewHelper.h"
#import "ControllerException.h"
#import "ORControllerConfig.h"

#import "ORControllerClient/ControllerREST_2_0_0_API.h"

@interface ORControllerPanelsFetcher ()

@property (nonatomic, retain) ORControllerConfig *controller;

@end

@implementation ORControllerPanelsFetcher

- (BOOL)shouldExecuteNow
{
    return [self.controller hasCapabilities];
}

// Note: cancel is not possible anymore, is this important ? If yes, how can we re-implement


- (void)send
{
    // TODO: there was a test to prevent re-use. Do we need to prevent that or is it now OK ?
//    NSAssert(!self.controllerRequest, @"ORControllerPanelsFetcher can only be used to send a request once");

    /*
    self.controllerRequest = [[[ControllerRequest alloc] initWithController:self.controller] autorelease];
    self.controllerRequest.delegate = self;
    [self.controllerRequest getRequestWithPath:[ServerDefinition controllerFetchPanelsPathForController:self.controller]];
     */
    ControllerREST_2_0_0_API *controllerAPI = [[ControllerREST_2_0_0_API alloc] init];
    
    [controllerAPI requestPanelIdentityListAtBaseURL:[NSURL URLWithString:self.controller.primaryURL]
                                  withSuccessHandler:^(NSArray *panels) {
                                      [self.delegate fetchPanelsDidSucceedWithPanels:[panels valueForKey:@"name"]];
                                  }
                                        errorHandler:^(NSError *error) {
                                            if ([self.delegate respondsToSelector:@selector(fetchPanelsDidFailWithError:)]) {
                                                [self.delegate fetchPanelsDidFailWithError:error];
                                            }
                                        }];
}

#pragma mark ControllerRequestDelegate implementation

// TODO: these 2 must be taken care of by new API

- (void)controllerRequestDidReceiveResponse:(NSURLResponse *)response
{
    int statusCode = ((NSHTTPURLResponse *)response).statusCode;
	if (statusCode != 200) {
		[ViewHelper showAlertViewWithTitle:@"Panel List Error" Message:[ControllerException controller:self.controller exceptionMessageOfCode:statusCode]];
	} 
}

- (void)controllerRequestRequiresAuthentication:(ControllerRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(fetchPanelsRequiresAuthenticationForControllerRequest:)]) {
        [self.delegate fetchPanelsRequiresAuthenticationForControllerRequest:request];
    }
}

@synthesize controller;
@synthesize delegate;

@end