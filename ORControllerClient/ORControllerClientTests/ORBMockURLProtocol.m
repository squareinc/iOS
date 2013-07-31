//
//  ORBMockURLProtocol.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

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
