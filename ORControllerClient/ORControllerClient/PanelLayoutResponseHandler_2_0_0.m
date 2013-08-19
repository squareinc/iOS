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
    if (self._errorCode) {
        // TODO: for certain error codes, we can parse XML and use that to build NSError
        // TODO: put appropriate information in userInfo dictionary
        self._errorHandler([NSError errorWithDomain:@"todo" code:self._errorCode userInfo:nil]);
    } else {
        PanelDefinitionParser *parser = [[PanelDefinitionParser alloc] init];
        self._successHandler([parser parseDefinitionFromXML:receivedData]);
        
        // TODO: handle parsing errors -> error handler
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self._errorCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        int responseCode = [((NSHTTPURLResponse *)response) statusCode];
        if (responseCode != 200) {
            self._errorCode = responseCode;
        }
    } else {
        // Handle as error, as this handler is only used for HTTP(S) communication

    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Framework reported error, just pass upwards
    self._errorHandler(error);
}


@end
