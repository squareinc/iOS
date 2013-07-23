//
//  PanelIdentityListResponseHandler_2_0_0.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 23/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "PanelIdentityListResponseHandler_2_0_0.h"

#import "ORPanelsParser.h"

@interface PanelIdentityListResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(NSArray *);
@property (strong, nonatomic) void (^_errorHandler)(NSError *);

@end

@implementation PanelIdentityListResponseHandler_2_0_0

- (id)initWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler
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
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:receivedData];
    self._successHandler([parser parsePanels]);

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
