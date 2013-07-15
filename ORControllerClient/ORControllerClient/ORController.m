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

#import "ORLabel.h"

@interface ORController ()

@property (strong, nonatomic) ORControllerAddress *address;
@property (nonatomic) BOOL connected;

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

- (void)readControllerConfigurationWithSuccessHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSError *))errorHandler;
{
    // TODO: need to fetch list of panels
    // TODO: then fetch first panel
    
    if (successHandler) {
        successHandler();
    }
}

- (NSArray *)allLabels
{
    // Must register the labels with the appropriate sensors so that text values are updated
    // and in turn appropriate notifications are posted
    
    return [NSSet setWithArray:@[[[ORLabel alloc] initWithText:@"Test label 1"]]];
}

@end
