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
 * Parses XML returned by "Sensor Status Request" or "Sensor Polling Request" REST API v 2.0.0
 *
 * @see http://openremote.org/display/docs/Controller+2.0+HTTP-REST-XML#Controller2.0HTTP-REST-XML-SensorStatusRequest
 * and http://openremote.org/display/docs/Controller+2.0+HTTP-REST-XML#Controller2.0HTTP-REST-XML-SensorPollingRequest
 */
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
 * Values are returned in a dictionary, key is sensorId (as an NSString *).
 *
 * @return A dictionary with sensor values
 */
- (NSDictionary *)parseValues;

@end
