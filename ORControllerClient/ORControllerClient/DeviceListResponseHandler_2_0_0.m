//
// Created by Gilles Durys on 30/10/15.
// Copyright (c) 2015 OpenRemote. All rights reserved.
//

#import "DeviceListResponseHandler_2_0_0.h"
#import "ORResponseHandler_Private.h"
#import "ORDevicesParser.h"

@interface DeviceListResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(NSArray *);

@end

@implementation DeviceListResponseHandler_2_0_0

- (instancetype)initWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler
{
    self = [super init];
    if (self) {
        self._successHandler = successHandler;
        self._errorHandler = errorHandler;
    }
    return self;
}

- (void)processValidResponseData:(NSData *)receivedData
{
    ORDevicesParser *parser = [[ORDevicesParser alloc] initWithData:receivedData];
    self._successHandler([parser parseDevices]);

    // TODO: handle parsing errors -> error handler
}
@end
