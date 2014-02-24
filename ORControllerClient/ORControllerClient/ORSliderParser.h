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

@class ORSlider;

/**
 * Parses a <slider...> XML fragment from the panel XML document
 * following schema v2.0 into an ORSlider model object instance.
 *
 * XML fragment example:
 * <slider id="60" thumbImage="thumbImage.png">
 *    <min value="0" image="mute.png" trackImage="red.png"/>
 *    <max value="100" image="loud.png" trackImage="green.png"/>
 *    <link type="sensor" ref="60" />
 * </slider>
 */
@interface ORSliderParser : DefinitionElementParser

/**
 * ORSlider model object parsed from the XML fragment.
 */
@property (nonatomic, strong, readonly) ORSlider *slider;

@end
