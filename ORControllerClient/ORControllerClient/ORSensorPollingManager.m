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

@interface ORSensorPollingManager ()

@property (nonatomic, weak) ORControllerAddress *_controllerAddress;
@property (nonatomic, strong) ORSensorRegistry *_sensorRegistry;

@end

@implementation ORSensorPollingManager

- (id)initWithControllerAddress:(ORControllerAddress *)controllerAddress sensorRegistry:(ORSensorRegistry *)sensorRegistry
{
    self = [super init];
    if (self) {
        self._controllerAddress = controllerAddress;
        self._sensorRegistry = sensorRegistry;
    }
    return self;
}

- (void)start
{
    ControllerREST_2_0_0_API *controllerAPI = [[ControllerREST_2_0_0_API alloc] init];
    [controllerAPI statusForSensorIds:[self._sensorRegistry sensorIds]
                            atBaseURL:self._controllerAddress.primaryURL
                   withSuccessHandler:^(NSDictionary *sensorValues) {
                       // Update text of labels
                       [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
                           NSSet *components = [self._sensorRegistry componentsLinkedToSensorId:[NSNumber numberWithInt:[sensorId intValue]]];
                           [components enumerateObjectsUsingBlock:^(NSObject * component, BOOL *stop) {
                               [component setValue:sensorValue forKey:@"text"]; // TODO: this is OK for labels, might not always be that property
                               
                               // TODO: must take state information from sensor into account to perform potential "translation"
                               
                           }];
                       }];
                       
                       __block void (^sensorPollingBlock)() = ^{
                           [controllerAPI pollSensorIds:[self._sensorRegistry sensorIds]
                               fromDeviceWithIdentifier:@"TODO"
                                              atBaseURL:self._controllerAddress.primaryURL
                                     withSuccessHandler:^(NSDictionary *sensorValues) {
                                         
                                         [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
                                             NSSet *components = [self._sensorRegistry componentsLinkedToSensorId:[NSNumber numberWithInt:[sensorId intValue]]];
                                             [components enumerateObjectsUsingBlock:^(NSObject * component, BOOL *stop) {
                                                 [component setValue:sensorValue forKey:@"text"]; // TODO: this is OK for labels, might not always be that property
                                             }];
                                         }];
                                         
                                         NSLog(@"poll got values");
                                         
                                         // TODO: fix the memory management issue
                                         
                                         sensorPollingBlock();
                                     } errorHandler:^(NSError *error) {
                                         
                                         NSLog(@"poll error %@", error);
                                         
                                         // TODO: if timeout, should call same block
                                         
                                     }];                           
                       };
                       
                       sensorPollingBlock();
                       
                       // TODO: should also start the polling
                       
                   }
                         errorHandler:^(NSError *error) {
                         }];
    
    // TODO: start the initial status request + polling loop
    // TODO: when would the loop be stopped -> on disconnect at least
}

- (void)stop
{
    // TODO : cancel pending operation + make sure we don't loop -> first might be enough if we have a Cancelled error
}

@end