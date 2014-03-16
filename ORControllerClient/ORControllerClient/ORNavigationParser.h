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

@class ORNavigation;

/**
 * Parses a <navigate...> XML fragment from the panel XML document
 * following schema v2.0 into an ORNavigation model object instance.
 *
 * XML fragment example:
 * <navigate toGroup="491" toScreen="493" />
 * or
 * <navigate to="setting" />
 */
@interface ORNavigationParser : DefinitionElementParser

/**
 * ORNavigation model object parsed from the XML fragment (navigate tag).
 */
@property (nonatomic, strong, readonly) ORNavigation *navigation;

@end
