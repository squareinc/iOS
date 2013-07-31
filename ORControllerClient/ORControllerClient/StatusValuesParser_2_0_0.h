//
//  StatusValuesParser_2_0_0.h
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusValuesParser_2_0_0 : NSObject <NSXMLParserDelegate>

/**
 * Initializes a parser with some sensor values data.
 *
 * @param data Data with XML describing sensor values
 *
 * @return a StatusValuesParser_2_0_0 instance initialized with the provided sensor values data
 */
- (id)initWithData:(NSData *)data;

/**
 * Parses the sensor values data and returns it.
 * Values are returned in a dictionary, key is sensorId.
 *
 * @return A dictionary with sensor values
 */
- (NSDictionary *)parseValues;

@end
