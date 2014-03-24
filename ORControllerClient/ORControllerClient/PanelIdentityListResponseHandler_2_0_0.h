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

#import "ORResponseHandler.h"

/**
 * Class in charge of handling the response (and error) of the REST call to retrieve panel identity list.
 * This applies for REST API v2.0.0
 */
@interface PanelIdentityListResponseHandler_2_0_0 : ORResponseHandler

/**
 * Initializes the response handler with the provided blocks for success and error handling.
 * 
 * @param successHandler A block object to be executed once call has successfully returned and the response data has been parsed.
 * This block has no return value and takes a single NSArray * argument with all the panel identities.
 * The elements of the array are ORPanel instances.
 * @param errorHandler A block object to be executed if call failed or response data can not be processed.
 * This block has no return value and takes a single NSError * argument indicating the error that occured. This parameter may be NULL.
 */
- (instancetype)initWithSuccessHandler:(void (^)(NSArray *))successHandler errorHandler:(void (^)(NSError *))errorHandler;

@end
