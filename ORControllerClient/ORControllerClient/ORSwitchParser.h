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

@class ORSwitch;

/**
 * Parses a <switch...> XML fragment from the panel XML document
 * following schema v2.0 into an ORSwitch model object instance.
 *
 * XML fragment example:
 * <switch id="60" >
 *    <link type="sensor" ref="60">
 *       <state name="on" value="c.png" />
 *       <state name="off" value="d.png" />
 *    </link>
 * </switch>
 */
@interface ORSwitchParser : DefinitionElementParser

/**
 * ORSwitch model object parsed from the XML fragment.
 */
@property (nonatomic, strong, readonly) ORSwitch *sswitch;

@end