/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

#import "ControllerREST_2_0_0_API.h"
#import "PanelIdentityListResponseHandler_2_0_0.h"
#import "PanelLayoutResponseHandler_2_0_0.h"

@implementation ControllerREST_2_0_0_API

// TODO: these methods might still return some form of Operation object
// can be used to cancel operation -> handlers not called ??? or errorHandler called with special Cancelled error
// cancel is important e.g. for panel layout, as it fetches all the images
// can also be used to check operation status

- (void)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                       withSuccessHandler:(void (^)(NSArray *))successHandler
                             errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[baseURL URLByAppendingPathComponent:@"/rest/panels"]];

    
// TODO    [CredentialUtil addCredentialToNSMutableURLRequest:request withUserName:userName password:password];

    // TODO: check for nil return value -> error
    // TODO: should someone keep the connection pointer and "nilify" when done ?
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:
                                   [[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:[[PanelIdentityListResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]]];
}

- (void)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                atBaseURL:(NSURL *)baseURL
                       withSuccessHandler:(void (^)(Definition *))successHandler
                             errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[baseURL URLByAppendingPathComponent:@"/rest/panel/"]
                                           URLByAppendingPathComponent:panelLogicalName]];
    
    // TODO: same as above method
    // TODO: how about caching and resources ??? These should not be at this level, this is pure REST API facade
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:
            [[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:[[PanelLayoutResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]]];

}

@end
