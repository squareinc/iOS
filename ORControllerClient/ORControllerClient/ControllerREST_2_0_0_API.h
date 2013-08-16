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

#import "ORControllerRESTAPI.h"

@class ORRESTCall;
@class Definition;

/**
 * Encapsulates the REST API for a specific version.
 * It always connects to the provided URL, does not know anything about group members.
 *
 // What about return codes (e.g. specific code for refresh -> 506, it's an error code, same as unauthorized)
 */
@interface ControllerREST_2_0_0_API : ORControllerRESTAPI

// TODO: how to specify credentials -> inject an authentication manager, has to authenticate request before sending
// how to get results / errors
- (ORRESTCall *)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(NSArray *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                        atBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(Definition *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)statusForSensorIds:(NSSet *)sensorIds
                         atBaseURL:(NSURL *)baseURL
                withSuccessHandler:(void (^)(NSDictionary *))successHandler
                      errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)pollSensorIds:(NSSet *)sensorIds fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                    atBaseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(NSDictionary *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler;

@end
