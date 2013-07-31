//
//  SensorValuesResponseHandler_2_0_0.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "SensorValuesResponseHandler_2_0_0.h"
#import "StatusValuesParser_2_0_0.h"

@interface SensorValuesResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(NSDictionary *);
@property (strong, nonatomic) void (^_errorHandler)(NSError *);

@end

@implementation SensorValuesResponseHandler_2_0_0

- (id)initWithSuccessHandler:(void (^)(NSDictionary *))successHandler errorHandler:(void (^)(NSError *))errorHandler;
{
    self = [super init];
    if (self) {
        self._successHandler = successHandler;
        self._errorHandler = errorHandler;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection receivedData:(NSData *)receivedData
{
    StatusValuesParser_2_0_0 *parser = [[StatusValuesParser_2_0_0 alloc] initWithData:receivedData];
    self._successHandler([parser parseValues]);
    
    // TODO: handle parsing errors -> error handler
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // TODO: is this required, what should we do here
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: do we want to encapsulate the error in one of our own ?
    self._errorHandler(error);
}

@end