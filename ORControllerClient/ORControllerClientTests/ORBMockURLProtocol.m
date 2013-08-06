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

#import "ORBMockURLProtocol.h"

// Can use host as a "command" to protocol
// port can also be usefull
// first path component is /
// second one can also be used
// after that is "standard" URL components : rest, panels ...
@implementation ORBMockURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [@"orbmock" isEqualToString:[[request URL] scheme]];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSLog(@"Request URL : %@", [self.request URL]);
    NSLog(@"Request URL host: %@", [[self.request URL] host]);
    NSLog(@"Request URL components : %@", [[self.request URL] pathComponents]);

    if ([@"panels" isEqualToString:[[[self.request URL] pathComponents] lastObject]]) {
        
        [self.client URLProtocol:self didReceiveResponse:[[NSURLResponse alloc] initWithURL:[self.request URL] MIMEType:@"application/xml" expectedContentLength:100 textEncodingName:nil] cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:[@"test" dataUsingEncoding:NSStringEncodingConversionAllowLossy]];
        [self.client URLProtocolDidFinishLoading:self];
        
//        - (void)URLProtocol:(NSURLProtocol *)protocol didFailWithError:(NSError *)error

    } else {
        [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:@"TODO" code:500 userInfo:nil]];
    }
}

- (void)stopLoading
{
    
}

@end
