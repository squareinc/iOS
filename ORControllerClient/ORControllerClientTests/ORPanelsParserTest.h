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

#import <SenTestingKit/SenTestingKit.h>

/**
 * Unit tests for ORPanelsParser
 */
@interface ORPanelsParserTest : SenTestCase

/**
 * Validates that, for a valid XML input, parsing does succeed.
 * Data file used is RequestPanelIdentityListValidResponse.xml, that is a copy from the one used as documentation in the Wiki at
 * http://openremote.org/display/docs/Controller+2.0+HTTP-REST-XML#Controller2.0HTTP-REST-XML-RequestPanelIdentityList
 *
 * Validates that:
 * - it does return a list as an NSArray
 * - the list contains the correct number of panels
 * - the list does contain only ORPanel instances (or subclasses)
 * - the name of each panel is as expected and in the same order as in the XML input
 */
- (void)testValidResponseParsing;

@end
