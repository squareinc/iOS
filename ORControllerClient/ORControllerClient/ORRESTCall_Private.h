/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
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

#import "ORRESTCall.h"

/**
 * Provides access to non public methods on ORRESTCall that should not be visible outside of this library implementation.
 */
@interface ORRESTCall ()

/**
 * Initializes the ORRESTCall with the requests and handler provided.
 * Creates the required underlying URL connection but does not start it yet.
 *
 * @param request Request to use to carry out the call
 * @param handler Handler used to process the response or handle the error
 *
 * @return An ORRESTCall object initialized with the provided information.
 */
- (instancetype)initWithRequest:(NSURLRequest *)request handler:(ORResponseHandler *)handler;

@end