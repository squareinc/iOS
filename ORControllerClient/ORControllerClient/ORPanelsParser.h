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
 * Parses XML returned by "Request Panel Identity List" REST API.
 *
 * @see http://openremote.org/display/docs/Controller+2.0+HTTP-REST-XML#Controller2.0HTTP-REST-XML-RequestPanelIdentityList
 */
@interface ORPanelsParser : NSObject <NSXMLParserDelegate>

/**
 * Initializes a parser with some panel data.
 *
 * @param data Data with XML describing panels list
 *
 * @return an ORPanelsParser instance initialized with the provided panel data
 */
- (id)initWithData:(NSData *)data;

/**
 * Parses the panel data and returns list of panel it describes.
 * Panels in the returned collection are in the same ordered as in the XML structure.
 *
 * @return A list of ORPanel objects
 */
- (NSArray *)parsePanels;

// TODO: how about error handling, raises exception ?

@end
