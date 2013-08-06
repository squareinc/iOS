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

#import "ORController.h"
#import "ORControllerAddress.h"
#import "ORSimpleUIConfiguration.h"
#import "ORSensorRegistry.h"
#import "ORPanel.h"
#import "Definition.h"
#import "Label.h"

#import "ORLabel.h"

#import "ControllerREST_2_0_0_API.h"

@interface ORController ()

@property (strong, nonatomic) ORControllerAddress *address;
@property (nonatomic) BOOL connected;

@property (nonatomic, strong) ORSensorRegistry *sensorRegistry;

@end

@implementation ORController

- (id)initWithControllerAddress:(ORControllerAddress *)anAddress
{
    self = [super init];
    if (self) {
        if (anAddress) {
            self.address = anAddress;
        } else {
            return nil;
        }
        self.sensorRegistry = [[ORSensorRegistry alloc] init];
    }
    return self;
}

- (void)connectWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;
{
    // In this first version, we actually do not try to connect at this stage but wait for read configuration request
    
    // TODO: in next version, could fetch group members
    // TODO: in later version, this could be a good place to get the controller capabilities
    // TODO: might also want to start the "polling / communication" loop 

    self.connected = YES;
    if (successHandler) {
        successHandler();
    }
}

- (void)disconnect
{
    // TODO: in later version, stop any communication with server e.g. polling loop
    
    self.connected = NO;
}

- (BOOL)isConnected
{
    return self.connected;
}

- (void)readSimpleUIConfigurationWithSuccessHandler:(void (^)(ORSimpleUIConfiguration *))successHandler
                                       errorHandler:(void (^)(NSError *))errorHandler
{
    // TODO: what if not connected, how to handle that: either report as an error or try to connect
    // but define it, document it and test/handle as appropriate in this implementation
    
    // TODO: if we already had a configuration and sensor polling going, we need to stop it
    // Maybe wait to have received new configuration before doing it ?
    
    ControllerREST_2_0_0_API *controllerAPI = [[ControllerREST_2_0_0_API alloc] init];
    
    [controllerAPI requestPanelIdentityListAtBaseURL:self.address.primaryURL withSuccessHandler:^(NSArray *panels) {
        // Get full definition of 1st panel, if there's one
        if ([panels count]) {
            [controllerAPI requestPanelLayoutWithLogicalName:((ORPanel *)[panels objectAtIndex:0]).name atBaseURL:self.address.primaryURL
                              withSuccessHandler:^(Definition *panelDefinition) {
                                  ORSimpleUIConfiguration *config = [[ORSimpleUIConfiguration alloc] init];
                                  // In this version, transorm all legacy Label objects to ORLabel
                                  // In the future, parsing should directly produce ORLabel instances
                                  NSMutableSet *orLabels = [NSMutableSet setWithCapacity:[panelDefinition.labels count]];
                                  [self.sensorRegistry clearRegistry];
                                  for (Label *label in panelDefinition.labels) {
                                      ORLabel *orLabel = [[ORLabel alloc] initWithText:label.text];
                                      [orLabels addObject:orLabel];
                                      
                                      if (label.sensor) {
                                          [self.sensorRegistry registerSensor:label.sensor linkedToComponent:orLabel];
                                      }
                                  }
                                  config.labels = [NSSet setWithSet:orLabels];
                                  
                                  [controllerAPI statusForSensorIds:[self.sensorRegistry sensorIds]
                                                          atBaseURL:self.address.primaryURL
                                                 withSuccessHandler:^(NSDictionary *sensorValues) {
                                                     // Update text of labels
                                                     [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
                                                         NSSet *components = [self.sensorRegistry componentsLinkedToSensorId:[NSNumber numberWithInt:[sensorId intValue]]];
                                                         [components enumerateObjectsUsingBlock:^(NSObject * component, BOOL *stop) {
                                                             [component setValue:sensorValue forKey:@"text"]; // TODO: this is OK for labels, might not always be that property
                                                         }];
                                                     }];
                                                     
                                                     __block void (^sensorPollingBlock)() = ^{
                                                         [controllerAPI pollSensorIds:[self.sensorRegistry sensorIds]
                                                             fromDeviceWithIdentifier:@"TODO"
                                                                            atBaseURL:self.address.primaryURL
                                                                   withSuccessHandler:^(NSDictionary *sensorValues) {
                                                                       
                                                                       [sensorValues enumerateKeysAndObjectsUsingBlock:^(NSString *sensorId, id sensorValue, BOOL *stop) {
                                                                           NSSet *components = [self.sensorRegistry componentsLinkedToSensorId:[NSNumber numberWithInt:[sensorId intValue]]];
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
                                                                       
                                                                       if (errorHandler) {
                                                                           // TODO: encapsulate error ?
                                                                           errorHandler(error);
                                                                       }
                                                                   }];

                                                     };
                                                     
                                                     sensorPollingBlock();
                                                     
                                                     // TODO: should also start the polling
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                               }
                                                       errorHandler:^(NSError *error) {
                                                         if (errorHandler) {
                                                             // TODO: encapsulate error ?
                                                             errorHandler(error);
                                                         }
                                                     }];
                                  
                                  // TODO: start the initial status request + polling loop
                                  // TODO: when would the loop be stopped -> on disconnect at least
                                  
                                  successHandler(config);
                                  
                              }
                                    errorHandler:^(NSError *error) {
                                        if (errorHandler) {
                                            // TODO: encapsulate error ?
                                            errorHandler(error);
                                        }
                                    }];
        } else {
            if (successHandler) {
                successHandler([[ORSimpleUIConfiguration alloc] init]);
            }
        }
    }
    errorHandler:^(NSError *error) {
        if (errorHandler) {
            // TODO: encapsulate error ?
            errorHandler(error);
        }
    }];
}

#pragma mark - Advanced iOS console only features

- (void)requestPanelIdentityListWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    // TODO: later based on information gathered during connect, would select the appropriate API/Object Model version
    
    ControllerREST_2_0_0_API *controllerAPI = [[ControllerREST_2_0_0_API alloc] init];
    
    [controllerAPI requestPanelIdentityListAtBaseURL:self.address.primaryURL
                                  withSuccessHandler:^(NSArray *panels) {
                                      successHandler(panels);
                                  }
                                        errorHandler:^(NSError *error) {
                                            if (errorHandler) {
                                                // TODO: encapsulate error ?
                                                errorHandler(error);
                                            }
                                        }];
}

- (void)requestPanelUILayout:(NSString *)panelName successHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    
    // TODO: this might be where the caching and resource fetching can take place ?
    
    ControllerREST_2_0_0_API *controllerAPI = [[ControllerREST_2_0_0_API alloc] init];
    
    [controllerAPI requestPanelLayoutWithLogicalName:panelName
                                           atBaseURL:self.address.primaryURL
                                  withSuccessHandler:^(Definition *panelDefinition) {
                                      successHandler(panelDefinition);
                                  }
                                        errorHandler:^(NSError *error) {
                                            if (errorHandler) {
                                                // TODO: encapsulate error ?
                                                errorHandler(error);
                                            }
                                        }];
}

@end