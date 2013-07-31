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
#import "ORControllerPollOrStatusSender.h"
#import "ServerDefinition.h"
#import "Definition.h"
#import "ORControllerConfig.h"
#import "ControllerException.h"
#import "StatusValuesParser_2_0_0.h"
#import "SensorStatusCache.h"

@interface ORControllerPollOrStatusSender()

@property (nonatomic, retain) ORControllerConfig *controller;
@property (nonatomic, retain) NSString *ids;
@property (nonatomic, retain) ControllerRequest *controllerRequest;

@end

@implementation ORControllerPollOrStatusSender

- (id)initWithController:(ORControllerConfig *)aController ids:(NSString *)someIds
{
    self = [super initWithController:aController];
    if (self) {
        self.ids = someIds;
    }
    return self;
}

- (void)dealloc
{
    self.ids = nil;
    self.delegate = nil;
    [super dealloc];
}

- (BOOL)shouldExecuteNow
{
    return [self.controller hasPanelIdentities];
}

- (void)handleServerResponseWithStatusCode:(int)statusCode
{
	if (statusCode != 200) {
		switch (statusCode) {
			case POLLING_TIMEOUT:
            {
                if ([self.delegate respondsToSelector:@selector(pollingDidTimeout)]) {
                    [self.delegate pollingDidTimeout];
                }
				return;
            }
		}		
        if ([self.delegate respondsToSelector:@selector(pollingDidReceiveErrorResponse)]) {
            [self.delegate pollingDidReceiveErrorResponse];
        }
        // [ViewHelper showAlertViewWithTitle:@"Polling Failed" Message:[ControllerException exceptionMessageOfCode:statusCode]];
        // Don't bother user with this, for now simply log
        NSLog(@"Polling failed %@", [ControllerException exceptionMessageOfCode:statusCode]);
        // TODO: user should be notified in an unobstrusive way that the polling did stop and there should be a way to restart it
	} else {
        if ([self.delegate respondsToSelector:@selector(pollingDidSucceed)]) {
            [self.delegate pollingDidSucceed];
        }
	} 
}

#pragma mark ControllerRequestDelegate implementation

- (void)controllerRequestDidFinishLoading:(NSData *)data
{
    StatusValuesParser_2_0_0 *parser = [[StatusValuesParser_2_0_0 alloc] initWithData:data];
    NSDictionary *values = [parser parseValues];
    
    [values enumerateKeysAndObjectsUsingBlock:^(id sensorId, id sensorValue, BOOL *stop) {
        if (![@"" isEqualToString:sensorValue]) {
            NSLog(@"change %@ to %@  !!!", sensorId, sensorValue);
            [self.controller.sensorStatusCache publishNewValue:sensorValue forSensorId:[sensorId intValue]];
        }
    }];
}

- (void)controllerRequestDidReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
	NSLog(@"polling[%@] statusCode is %d", self.ids, [httpResp statusCode]);
	
	[self handleServerResponseWithStatusCode:[httpResp statusCode]];
}

- (void)controllerRequestDidFailWithError:(NSError *)error
{
	if ([self.delegate respondsToSelector:@selector(pollingDidFailWithError:)]) {
        [self.delegate pollingDidFailWithError:error];
    }
}

- (void)controllerRequestConfigurationUpdated:(ControllerRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(controllerConfigurationUpdated:)]) {
        [self.delegate controllerConfigurationUpdated:request.controller];
    }    
}

@synthesize controller;
@synthesize ids;
@synthesize controllerRequest;
@synthesize delegate;

@end