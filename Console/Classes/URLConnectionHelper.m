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
#import "URLConnectionHelper.h"
#import "AppSettingsDefinition.h"
#import "CheckNetwork.h"
#import "CheckNetworkException.h"
#import "NotificationConstant.h"

#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"

#pragma mark main class URLConnectionHelper
//Helper for NSURLConnection async or sync request. use HTTPS self-certificate. 
//switch to another server when connection fail.
@interface URLConnectionHelper (Private)

- (void) removeBadCurrentServerURL;
- (void) swithToGroupMemberServer;
- (NSString *) checkGroupMemberServers;

@end

// a static flag for WIFI activity.
// iphone will disconnect from WIFI when in sleep mode.
static BOOL isWifiActive = NO;

@implementation URLConnectionHelper 

@synthesize delegate, connection, errorMsg, getAutoServersTimer;


#pragma mark WIFI activity flag getter/setter
+ (BOOL)isWifiActive {
	return isWifiActive;
}

+ (void)setWifiActive:(BOOL)active {
	isWifiActive = active;
}

#pragma mark init
- (id)initWithURL:(NSURL *)url delegate:(id <URLConnectionHelperDelegate>)d  {
    self = [super init];
	if (self) {
		[self setDelegate:d];
		
		receivedData = [[NSMutableData alloc] init];
		
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
		
		//the initWithRequest constractor will invoke the request
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
	}
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id <URLConnectionHelperDelegate>)d  {
    self = [super init];
	if (self) {
		[self setDelegate:d];
		
		receivedData = [[NSMutableData alloc] init];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	return self;
}

- (void)cancelConnection {
    NSLog(@"Asked to cancel connection %@", connection);
	if (connection) {
		NSLog(@"Connection exists, will cancel it");
		[connection cancel];
		if (connection) {
			[connection release];
			connection = nil;
		}
	}
}

#pragma mark delegate method of NSURLConnection

//Called we connection receive data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// Append data
	[receivedData appendData:data];
}

// When finished the connection invoke the deleget method
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Send data to delegate
	//[delegate performSelector:@selector(definitionURLConnectionDidFinishLoading:) withObject:receivedData afterDelay:5];
	[delegate definitionURLConnectionDidFinishLoading:receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if ([delegate respondsToSelector:@selector(definitionURLConnectionDidFailWithError:)]) {
        
        NSLog(@">>>>>>>>>>connection:didFailWithError:");
        
		[delegate definitionURLConnectionDidFailWithError:error];
		self.errorMsg = error;
        NSLog(@"isWifiActive %d", isWifiActive);
// EBR : why this test ?
//		if ([URLConnectionHelper isWifiActive]) {
			[self swithToGroupMemberServer];
//		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Occured" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (delegate && [delegate respondsToSelector:@selector(definitionURLConnectionDidReceiveResponse:)]) {
		[delegate definitionURLConnectionDidReceiveResponse:response];
	}
}

// HTTPS self-certificate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"[async] use HTTPS self-certificate");
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	}
}

#pragma mark Delegate method of UpdateController
- (void)didUpdate {
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationRefreshGroupsView object:nil];
}

- (void)didUseLocalCache:(NSString *)errorMessage {
	if ([errorMessage isEqualToString:@"401"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopulateCredentialView object:nil];
	} else {
		[ViewHelper showAlertViewWithTitle:@"Use Local Cache" Message:errorMessage];
	}
}

- (void)didUpdateFail:(NSString *)errorMessage
{
}

- (void)dealloc {
	[receivedData release];
	[connection release];
	[getAutoServersTimer release];
	[super dealloc];
}

@end
