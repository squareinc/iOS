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

#import "ORSensorPollingManager.h"
#import "ORControllerAddress.h"
#import "ORSensorRegistry.h"
#import "ORSensorLink.h"
#import "Sensor.h"
#import "ORRESTCall.h"
#import "ORControllerRESTAPI.h"

@interface ORSensorPollingManager ()

@property (nonatomic, strong) ORControllerRESTAPI *_controllerAPI;
@property (nonatomic, strong) ORControllerAddress *_controllerAddress;
@property (nonatomic, strong) ORSensorRegistry *_sensorRegistry;

@property (nonatomic, strong) ORRESTCall *_currentCall;

@end

@implementation ORSensorPollingManager

- (id)initWithControllerAPI:(ORControllerRESTAPI *)api
          controllerAddress:(ORControllerAddress *)controllerAddress
             sensorRegistry:(ORSensorRegistry *)sensorRegistry
{
    self = [super init];
    if (self) {
        self._controllerAPI = api;
        self._controllerAddress = controllerAddress;
        self._sensorRegistry = sensorRegistry;
    }
    return self;
}

// TODO: Q ? how are error reported on start, during poll ?
// delegate ?
// do we also have some isPolling flag ?

- (void)start
{
    // Only poll if there are sensors to poll
    if (![[self._sensorRegistry sensorIds] count]) {
        return;
    }
    __block void (^sensorPollingBlock)() = ^{
        self._currentCall = [self._controllerAPI pollSensorIds:[self._sensorRegistry sensorIds]
                                fromDeviceWithIdentifier:@"TODO"
                                               atBaseURL:self._controllerAddress.primaryURL
                                      withSuccessHandler:^(NSDictionary *sensorValues) {
                                          
                                          [self updateComponentsWithSensorValues:sensorValues];
                                          
                                          NSLog(@"poll got values");
                                          
                                          // TODO: fix the memory management issue
                                          
                                          sensorPollingBlock();
                                      } errorHandler:^(NSError *error) {
                                          
                                          NSLog(@"poll error %@", error);
                                          
                                          // TODO: if timeout, should call same block
                                          
                                      }];
    };

    self._currentCall = [self._controllerAPI statusForSensorIds:[self._sensorRegistry sensorIds]
                            atBaseURL:self._controllerAddress.primaryURL
                   withSuccessHandler:^(NSDictionary *sensorValues) {
                       [self updateComponentsWithSensorValues:sensorValues];
                       sensorPollingBlock();
                   }
                         errorHandler:^(NSError *error) {
                         }];
}

- (void)stop
{
    [self._currentCall cancel];
    self._currentCall = nil;
    // TODO: make sure we don't loop -> cancel might be enough if we make sure we don't restart polling (e.g. have a Cancelled error)
}

- (void)updateComponentsWithSensorValues:(NSDictionary *)sensorValues
{
    // Update properties of linked element
    [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
        NSNumber *sensorIdAsNumber = [NSNumber numberWithInt:[sensorId intValue]];
        NSSet *sensorLinks = [self._sensorRegistry sensorLinksForSensorId:sensorIdAsNumber];
        Sensor *sensor = [self._sensorRegistry sensorWithId:sensorIdAsNumber];
        // "Map" given sensor value according to defined sensor states
        NSString *mappedSensorValue = [sensor stateValueForName:sensorValue];
        // If no mapping, use received sensor value as is
        if (!mappedSensorValue) {
            mappedSensorValue = sensorValue;
        }
        [sensorLinks enumerateObjectsUsingBlock:^(ORSensorLink *link, BOOL *stop) {
            [link.component setValue:mappedSensorValue forKey:link.propertyName];
        }];
    }];
}

@end
