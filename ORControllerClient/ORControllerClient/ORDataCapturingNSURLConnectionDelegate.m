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

#pragma mark - Handling of non implemented methods forwarding

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

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self isDelegateSelector:aSelector]) {
        return self.delegate;
    }
    return nil;
}

#pragma mark - Capturing the data

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate connectionDidFinishLoading:connection receivedData:self.receivedData];
}

@synthesize delegate;
@synthesize receivedData;

@end