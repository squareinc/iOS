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
#import "ORDevice.h"
#import "ORDeviceCommand.h"

NSString *const kORClientErrorDomain = @"org.openremote.ORClientDomain";

@implementation ORControllerRESTAPI

- (ORRESTCall *)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(NSArray *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                        atBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(Definition *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)retrieveResourceNamed:(NSString *)resourceName
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSData *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)statusForSensorIds:(NSSet *)sensorIds
                         atBaseURL:(NSURL *)baseURL
                withSuccessHandler:(void (^)(NSDictionary *))successHandler
                      errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}


- (ORRESTCall *)pollSensorIds:(NSSet *)sensorIds fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                    atBaseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(NSDictionary *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)statusForSensorIdentifiers:(NSSet *)sensorIdentifiers
                                 atBaseURL:(NSURL *)baseURL
                        withSuccessHandler:(void (^)(NSDictionary *))successHandler
                              errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}


- (ORRESTCall *)pollSensorIdentifiers:(NSSet *)sensorIdentifiers fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSDictionary *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)controlForWidget:(ORWidget *)widget // TODO: should we pass widget or just identifier
                          action:(NSString *)action // TODO: should this be given as param or infered from widget or ...
                       atBaseURL:(NSURL *)baseURL
              withSuccessHandler:(void (^)(void))successHandler // TODO: required ? anything meaningful to return ?
                    errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)requestDevicesListAtBaseURL:(NSURL *)baseURL
                 withSuccessHandler:(void (^)(NSArray *))successHandler
                       errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)requestDevice:(ORDevice *)device
                      baseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(ORDevice *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)executeCommand:(ORDeviceCommand *)command parameter:(NSString *)parameter baseURL:(NSURL *)baseURL withSuccessHandler:(void (^)())successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}


@end