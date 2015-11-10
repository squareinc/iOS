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

#import <Foundation/Foundation.h>

@protocol ORAuthenticationManager;

@class ORRESTCall;
@class Definition;
@class ORWidget;
@class ORDevice;
@class ORDeviceCommand;

/**
 * Error domain used for NSError specific to the ORClient library.
 */
extern NSString *const kORClientErrorDomain;

#define STATUS_CODE_OR_SPECIFIC(statusCode) ((statusCode == EINVALID_PANEL_XML) \
                                            || (statusCode == EPANEL_XML_NOT_DEPLOYED) \
                                            || (statusCode == EPANEL_NAME_NOT_FOUND))
/**
 * Encapsulates the REST API for talking to the ORB.
 * Subclasses will provide implementation for specific versions of the API.
*/
@interface ORControllerRESTAPI : NSObject

- (ORRESTCall *)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(NSArray *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                        atBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(Definition *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)retrieveResourceNamed:(NSString *)resourceName
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSData *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)statusForSensorIds:(NSSet *)sensorIds
                         atBaseURL:(NSURL *)baseURL
                withSuccessHandler:(void (^)(NSDictionary *))successHandler
                      errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)pollSensorIds:(NSSet *)sensorIds fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                    atBaseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(NSDictionary *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)statusForSensorIdentifiers:(NSSet *)sensorIdentifiers
                                 atBaseURL:(NSURL *)baseURL
                        withSuccessHandler:(void (^)(NSDictionary *))successHandler
                              errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)pollSensorIdentifiers:(NSSet *)sensorIdentifiers fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSDictionary *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)controlForWidget:(ORWidget *)widget // TODO: should we pass widget or just identifier
                          action:(NSString *)action // TODO: should this be given as param or infered from widget or ...
                       atBaseURL:(NSURL *)baseURL
              withSuccessHandler:(void (^)(void))successHandler // TODO: required ? anything meaningful to return ?
                    errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)requestDevicesListAtBaseURL:(NSURL *)baseURL
                         withSuccessHandler:(void (^)(NSArray *))successHandler
                               errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)requestDevice:(ORDevice *)device
                      baseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(ORDevice *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler;

- (ORRESTCall *)executeCommand:(ORDeviceCommand *)command parameter:(NSString *)parameter baseURL:(NSURL *)baseURL withSuccessHandler:(void (^)())successHandler errorHandler:(void (^)(NSError *))errorHandler;

/**
 * The authentication manager that can provide credential during calls.
 */
@property (nonatomic, strong) NSObject <ORAuthenticationManager> *authenticationManager;

@end
