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
#import "WebSubController.h"
#import "ORControllerClient/ORWeb.h"
#import "SensorStatusCache.h"
#import "ORControllerClient/Sensor.h"
#import "ORControllerClient/NSStringAdditions.h"

@interface WebSubController()

@property (nonatomic, readwrite, strong) UIView *view;
@property (weak, nonatomic, readonly) ORWeb *web;
@property (nonatomic, strong) NSString *oldStatus;

- (void)loadRequestForURL:(NSString *)url;

@end

@implementation WebSubController

- (id)initWithController:(ORControllerConfig *)aController imageCache:(ImageCache *)aCache component:(Component *)aComponent
{
    self = [super initWithController:aController imageCache:aCache component:aComponent];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.view = webView;
        [self loadRequestForURL:self.web.src];
    }
    
    return self;
}


- (ORWeb *)web
{
    return (ORWeb *)self.component;
}

- (void)loadRequestForURL:(NSString *)url
{
	ORWeb *webModel = (ORWeb *)self.component;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	// If a username if provided in the config, use that for authentication
	if (webModel.username != nil && ![@"" isEqualToString:webModel.username]) {
		NSData *authData = [[NSString stringWithFormat:@"%@:%@", webModel.username, webModel.password] dataUsingEncoding:NSUTF8StringEncoding];
		NSString *authString = [NSString base64StringFromData:authData length:[authData length]];
		authString = [NSString stringWithFormat: @"Basic %@", authString];
		[request setValue:authString forHTTPHeaderField:@"Authorization"];
	}
	
	[(UIWebView *)self.view loadRequest:request];    
}

- (void)setPollingStatus:(NSNotification *)notification
{
	SensorStatusCache *statusCache = (SensorStatusCache *)[notification object];
	int sensorId = self.web.sensor.sensorId;
	NSString *newStatus = [statusCache valueForSensorId:sensorId];
    if (![self.oldStatus isEqualToString:newStatus]) {
        self.oldStatus = newStatus;
        [self loadRequestForURL:newStatus];
    }
}

@synthesize view;
@synthesize oldStatus;

@end