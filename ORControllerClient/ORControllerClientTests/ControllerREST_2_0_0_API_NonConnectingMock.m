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

#import "ControllerREST_2_0_0_API_NonConnectingMock.h"
#import "ORRestCallMock.h"

#import "ORDataCapturingNSURLConnectionDelegate.h"

@implementation ControllerREST_2_0_0_API_NonConnectingMock

- (ORRESTCall *)callForRequest:(NSURLRequest *)request delegate:(id <ORDataCapturingNSURLConnectionDelegateDelegate>)delegate
{
    ORRestCallMock *call = [[ORRestCallMock alloc] init];
    call.requestURL = [[request URL] absoluteString];
    return (ORRESTCall *)call;
}

@end
