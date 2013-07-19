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
#import <Foundation/Foundation.h>

/**
 * Decorated delegate protocol that should be implemented instead of NSURLConnectionDataDelegate.
 */
@protocol ORDataCapturingNSURLConnectionDelegateDelegate <NSURLConnectionDataDelegate>

/**
 * Sent when a connection has finished loading successfully.
 * This replaces the connectionDidFinishLoading: message from the standard NSURLConnectionDataDelegate
 * protocol, is sent at the same time in the connection lifecycle and obeys the same rules.
 *
 * @param connection The connection sending the message.
 * @param receivedData All the data that has been received from the connection.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection receivedData:(NSData *)receivedData;

@end

/**
 * This is a Decorator to be used on objects setting themselves as delegate of NSURLConnection.
 * The delegate methods from NSURLConnection do provide data to its delegate in several chunk as
 * it gets received on the connection.
 *
 * The goal of this class is to accumulate all data in a buffer and pass it in one go to the delegate
 * once the transmission is completed.
 *
 * This is done with the new connectionDidFinishLoading:receivedData: method that delegates must implement.
 * The standard connection:didReceiveData: and connectionDidFinishLoading: delegate methods are captured by
 * this class and replaced with the above method (and so not forwarded to the encapsulated object).
 *
 * All other delegate methods are forwarded to encapsulated object.
 */
@interface ORDataCapturingNSURLConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

/**
 * Initializes this object with the delegates it must decorate.
 *
 * @param aDelegate the delegate to decorate
 *
 * @return an encapsulated NSURLConnectionDataDelegate instance
 */
- (id)initWithNSURLConnectionDelegate:(id <ORDataCapturingNSURLConnectionDelegateDelegate>)aDelegate;

@end
