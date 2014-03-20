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
#import "DefinitionElementParser.h"

@class ORScreen;

/**
 * Parses a <screen...> XML fragment from the panel XML document
 * following schema v2.0 into an ORScreen model object instance.
 *
 * XML fragment example:
 * <screen id="5" name="basement">
 *    <background absolute="100,100">
 *       <image src="basement1.png" />
 *    </background>
 *    <absolute left="20" top="320" width="100" height="100" >
 *       <image id="59" src = "a.png" />
 *    </absolute>
 *    <absolute left="20" top="320" width="100" height="100" >
 *       <image id="60" src = "b.png" />
 *    </absolute>
 * </screen>
 */

@interface ORScreenParser : DefinitionElementParser

/**
 * ORScreen model object parsed from the XML fragment.
 */
@property (nonatomic, strong, readonly) ORScreen *screen;

@end