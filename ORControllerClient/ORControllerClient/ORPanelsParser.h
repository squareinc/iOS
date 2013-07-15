//
//  ORPanelsParser.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

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
