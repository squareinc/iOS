//
//  PanelLayoutResponseHandler_2_0_0.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "PanelLayoutResponseHandler_2_0_0.h"
#import "PanelDefinitionParser.h"

@interface PanelLayoutResponseHandler_2_0_0 ()

@property (strong, nonatomic) void (^_successHandler)(Definition *);
@property (strong, nonatomic) void (^_errorHandler)(NSError *);

@end

@implementation PanelLayoutResponseHandler_2_0_0

- (id)initWithSuccessHandler:(void (^)(Definition *))successHandler errorHandler:(void (^)(NSError *))errorHandler
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
    PanelDefinitionParser *parser = [[PanelDefinitionParser alloc] init];
    self._successHandler([parser parseDefinitionFromXML:receivedData]);
    
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
