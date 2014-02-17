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
#import "SensorValuesResponseHandler_2_0_0.h"
#import "ORRESTCall_Private.h"
#import "ORObjectIdentifier.h"
#import "ORWidget.h"

@interface ControllerREST_2_0_0_API ()

- (ORRESTCall *)callForRequest:(NSURLRequest *)request delegate:(ORResponseHandler *)handler;

@end

@implementation ControllerREST_2_0_0_API

// Encapsulate delegate in ORDataCapturingNSURLConnectionDelegate before passing to created connection
- (ORRESTCall *)callForRequest:(NSURLRequest *)request delegate:(ORResponseHandler *)handler
{
    handler.authenticationManager = self.authenticationManager;
    return [[ORRESTCall alloc] initWithNSURLConnection:
            [[NSURLConnection alloc] initWithRequest:request
                                            delegate:[[ORDataCapturingNSURLConnectionDelegate alloc] initWithNSURLConnectionDelegate:handler]]];
}

// TODO: these methods might still return some form of Operation object
// can be used to cancel operation -> handlers not called ??? or errorHandler called with special Cancelled error
// cancel is important e.g. for panel layout, as it fetches all the images
// can also be used to check operation status

- (ORRESTCall *)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                       withSuccessHandler:(void (^)(NSArray *))successHandler
                             errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[baseURL URLByAppendingPathComponent:@"/rest/panels"]];
    
// TODO    [CredentialUtil addCredentialToNSMutableURLRequest:request withUserName:userName password:password];

    // TODO: check for nil return value -> error
    // TODO: should someone keep the connection pointer and "nilify" when done ?
    return [self callForRequest:request delegate:[[PanelIdentityListResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                atBaseURL:(NSURL *)baseURL
                       withSuccessHandler:(void (^)(Definition *))successHandler
                             errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[baseURL URLByAppendingPathComponent:@"/rest/panel/"]
                                           URLByAppendingPathComponent:panelLogicalName]];
    
    // TODO: same as above method
    // TODO: how about caching and resources ??? These should not be at this level, this is pure REST API facade
    return [self callForRequest:request delegate:[[PanelLayoutResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)statusForSensorIds:(NSSet *)sensorIds
               atBaseURL:(NSURL *)baseURL
      withSuccessHandler:(void (^)(NSDictionary *))successHandler
            errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[baseURL URLByAppendingPathComponent:@"/rest/status/"]
                                                                        URLByAppendingPathComponent:[[sensorIds allObjects] componentsJoinedByString:@","]]];
    
    return [self callForRequest:request delegate:[[SensorValuesResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)pollSensorIds:(NSSet *)sensorIds fromDeviceWithIdentifier:(NSString *)deviceIdentifier
          atBaseURL:(NSURL *)baseURL
 withSuccessHandler:(void (^)(NSDictionary *))successHandler
       errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[[baseURL URLByAppendingPathComponent:@"/rest/polling/"]
                                                                        URLByAppendingPathComponent:deviceIdentifier]
                                                                        URLByAppendingPathComponent:[[sensorIds allObjects] componentsJoinedByString:@","]]];

    return [self callForRequest:request delegate:[[SensorValuesResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)statusForSensorIdentifiers:(NSSet *)sensorIdentifiers
                                 atBaseURL:(NSURL *)baseURL
                        withSuccessHandler:(void (^)(NSDictionary *))successHandler
                              errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[baseURL URLByAppendingPathComponent:@"/rest/status/"]
                                                                        URLByAppendingPathComponent:[[[sensorIdentifiers allObjects] valueForKey:@"stringValue"] componentsJoinedByString:@","]]];
    
    return [self callForRequest:request delegate:[[SensorValuesResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)pollSensorIdentifiers:(NSSet *)sensorIdentifiers fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSDictionary *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[[baseURL URLByAppendingPathComponent:@"/rest/polling/"]
                                                                         URLByAppendingPathComponent:deviceIdentifier]
                                                                        URLByAppendingPathComponent:[[[sensorIdentifiers allObjects] valueForKey:@"stringValue"] componentsJoinedByString:@","]]];
    
    return [self callForRequest:request delegate:[[SensorValuesResponseHandler_2_0_0 alloc] initWithSuccessHandler:successHandler errorHandler:errorHandler]];
}

- (ORRESTCall *)controlForWidget:(ORWidget *)widget // TODO: should we pass widget or just identifier
                          action:(NSString *)action // TODO: should this be given as param or infered from widget or ...
                       atBaseURL:(NSURL *)baseURL
              withSuccessHandler:(void (^)(void))successHandler // TODO: required ? anything meaningful to return ?
                    errorHandler:(void (^)(NSError *))errorHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[[baseURL URLByAppendingPathComponent:@"/rest/control/"]
                                                                         URLByAppendingPathComponent:[widget.identifier stringValue]]
                                                                        URLByAppendingPathComponent:action]];
    return [self callForRequest:request delegate:nil]; // TODO: delegate
}

@end
