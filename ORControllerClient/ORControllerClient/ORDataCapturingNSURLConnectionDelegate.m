/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "ORDataCapturingNSURLConnectionDelegate.h"
#import "ORRuntimeUtils.h"

#define NUM_DELEGATE_METHODS 10

@interface ORDataCapturingNSURLConnectionDelegate ()

@property (nonatomic, strong) NSObject <ORDataCapturingNSURLConnectionDelegateDelegate> *delegate;
@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation ORDataCapturingNSURLConnectionDelegate

static NSArray* connectionDelegateSelectors;

+ (void)initialize
{
    NSMutableArray *tmp = [NSMutableArray array];
    
    // We'll intercept and forward methods in the NSURLConnectionDelegate
    [tmp addObjectsFromArray:[ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(NSURLConnectionDelegate)]];
    // and NSURLConnectionDataDelegate protocols
    [tmp addObjectsFromArray:[ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(NSURLConnectionDataDelegate)]];
    
    // Make sure methods we do implement are not in that array otherwhise we might not get the call
    [tmp removeObject:[NSValue valueWithPointer:@selector(connection:didReceiveData:)]];
    [tmp removeObject:[NSValue valueWithPointer:@selector(connectionDidFinishLoading:)]];
    
    connectionDelegateSelectors = [NSArray arrayWithArray:tmp];
}

- (id)initWithNSURLConnectionDelegate:(id <ORDataCapturingNSURLConnectionDelegateDelegate>)aDelegate;
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        self.receivedData = [NSMutableData dataWithCapacity:0];
    }
    return self;
}

#pragma mark -

- (BOOL)isDelegateSelector:(SEL)selector
{
    return [connectionDelegateSelectors containsObject:[NSValue valueWithPointer:selector]];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self isDelegateSelector:aSelector]) {
        return [self.delegate respondsToSelector:aSelector];
    }
    return [super respondsToSelector:aSelector];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate connectionDidFinishLoading:connection receivedData:self.receivedData];
}

#pragma mark - Forwarded NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.delegate connection:connection didFailWithError:error];
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(connectionShouldUseCredentialStorage:)]) {
        return [self.delegate connectionShouldUseCredentialStorage:connection];
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([self.delegate respondsToSelector:@selector(connection:willSendRequestForAuthenticationChallenge:)]) {
        [self.delegate connection:connection willSendRequestForAuthenticationChallenge:challenge];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if ([self.delegate respondsToSelector:@selector(connection:canAuthenticateAgainstProtectionSpace:)]) {
        return [self.delegate connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveAuthenticationChallenge:)]) {
        [self.delegate connection:connection didReceiveAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([self.delegate respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)]) {
        [self.delegate connection:connection didCancelAuthenticationChallenge:challenge];
    }
}

#pragma mark - Forwarded NSURLConnectionDataDelegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
        return [self.delegate connection:connection willSendRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.delegate connection:connection didReceiveResponse:response];
    }
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(connection:needNewBodyStream:)]) {
        return [self.delegate connection:connection needNewBodyStream:request];
    }
    return nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ([self.delegate respondsToSelector:@selector(connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [self.delegate connection:connection didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    if ([self.delegate respondsToSelector:@selector(connection:willCacheResponse:)]) {
        return [self.delegate connection:connection willCacheResponse:cachedResponse];
    }
    return cachedResponse;
}

@synthesize delegate;
@synthesize receivedData;

@end