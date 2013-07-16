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
#import "Definition.h"
#import "ViewHelper.h"
#import "ControllerException.h"
#import "ORControllerConfig.h"

#import "ORPanelsParser.h"

@interface ORControllerPanelsFetcher ()

@property (nonatomic, retain) ControllerRequest *controllerRequest;
@property (nonatomic, retain) ORControllerConfig *controller;

@end

@implementation ORControllerPanelsFetcher

- (BOOL)shouldExecuteNow
{
    return [self.controller hasCapabilities];
}

- (void)send
{
    NSAssert(!self.controllerRequest, @"ORControllerPanelsFetcher can only be used to send a request once");

    self.controllerRequest = [[[ControllerRequest alloc] initWithController:self.controller] autorelease];
    self.controllerRequest.delegate = self;
    [self.controllerRequest getRequestWithPath:[ServerDefinition controllerFetchPanelsPathForController:self.controller]];
}

#pragma mark ControllerRequestDelegate implementation

- (void)controllerRequestDidFinishLoading:(NSData *)data
{
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    [self.delegate fetchPanelsDidSucceedWithPanels:[panels valueForKey:@"name"]];
    [parser release];
}

// optional TODO EBR is it required
- (void)controllerRequestDidFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(fetchPanelsDidFailWithError:)]) {
        [self.delegate fetchPanelsDidFailWithError:error];
    }
}

- (void)controllerRequestDidReceiveResponse:(NSURLResponse *)response
{
    int statusCode = ((NSHTTPURLResponse *)response).statusCode;
	if (statusCode != 200) {
		[ViewHelper showAlertViewWithTitle:@"Panel List Error" Message:[ControllerException exceptionMessageOfCode:statusCode]];	
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
@synthesize controllerRequest;

@end