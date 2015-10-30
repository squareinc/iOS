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

#import "DeviceResponseHandler_2_0_0.h"
#import "ORResponseHandler_Private.h"
#import "ORDevice.h"
#import "ORDeviceParser.h"

@interface DeviceResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(ORDevice *);
@property(nonatomic, strong) ORDevice *device;

@end

@implementation DeviceResponseHandler_2_0_0

- (instancetype)initWithDevice:(ORDevice *)device successHandler:(void (^)(ORDevice *))successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    self = [super init];
    if (self) {
        self._successHandler = successHandler;
        self._errorHandler = errorHandler;
        self.device = device;
    }
    return self;
}

- (void)processValidResponseData:(NSData *)receivedData
{
    ORDeviceParser *parser = [[ORDeviceParser alloc] initWithData:receivedData];
    parser.device = self.device;
    self._successHandler([parser parseDevice]);

    // TODO: handle parsing errors -> error handler
}

@end
