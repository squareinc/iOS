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

#import "ORControllerRESTAPI_ScriptableMock.h"

@implementation ORControllerRESTAPI_ScriptableMock

- (ORRESTCall *)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(NSArray *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler
{
    if (self.panelIdentityListError) {
        errorHandler(self.panelIdentityListError);
    } else if (self.panelIdentityListResult) {
        successHandler(self.panelIdentityListResult);
    }
    return nil;
}

- (ORRESTCall *)requestPanelLayoutWithLogicalName:(NSString *)panelLogicalName
                                        atBaseURL:(NSURL *)baseURL
                               withSuccessHandler:(void (^)(Definition *))successHandler
                                     errorHandler:(void (^)(NSError *))errorHandler
{
    return nil;
}

- (ORRESTCall *)statusForSensorIds:(NSSet *)sensorIds
                         atBaseURL:(NSURL *)baseURL
                withSuccessHandler:(void (^)(NSDictionary *))successHandler
                      errorHandler:(void (^)(NSError *))errorHandler
{
    self.sensorStatusCallCount++;
    if (self.sensorStatusError) {
        errorHandler(self.sensorStatusError);
    } else if (self.sensorStatusResult) {
        successHandler(self.sensorStatusResult);
    }
    return nil;
}

- (ORRESTCall *)pollSensorIds:(NSSet *)sensorIds fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                    atBaseURL:(NSURL *)baseURL
           withSuccessHandler:(void (^)(NSDictionary *))successHandler
                 errorHandler:(void (^)(NSError *))errorHandler
{
    if (self.sensorPollCallCount >= self.sensorPollMaxCall) {
        return nil;
    }

    self.sensorPollCallCount++;
    if (self.sensorPollError) {
        errorHandler(self.sensorPollError);
    } else if (self.sensorPollResult) {
        successHandler(self.sensorPollResult);
    }

    return nil;
}

- (ORRESTCall *)statusForSensorIdentifiers:(NSSet *)sensorIdentifiers
                                 atBaseURL:(NSURL *)baseURL
                        withSuccessHandler:(void (^)(NSDictionary *))successHandler
                              errorHandler:(void (^)(NSError *))errorHandler
{
    self.sensorStatusCallCount++;
    if (self.sensorStatusError) {
        errorHandler(self.sensorStatusError);
    } else if (self.sensorStatusResult) {
        successHandler(self.sensorStatusResult);
    }
    return nil;
}

- (ORRESTCall *)pollSensorIdentifiers:(NSSet *)sensorIdentifiers fromDeviceWithIdentifier:(NSString *)deviceIdentifier
                            atBaseURL:(NSURL *)baseURL
                   withSuccessHandler:(void (^)(NSDictionary *))successHandler
                         errorHandler:(void (^)(NSError *))errorHandler
{
    if (self.sensorPollCallCount >= self.sensorPollMaxCall) {
        return nil;
    }
    
    self.sensorPollCallCount++;
    if (self.sensorPollError) {
        errorHandler(self.sensorPollError);
    } else if (self.sensorPollResult) {
        successHandler(self.sensorPollResult);
    }
    
    return nil;
}

@end