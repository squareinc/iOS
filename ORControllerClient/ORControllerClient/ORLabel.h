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

#import <UIKit/UIKit.h>
#import "ORWidget.h"

/**
 * Model object representing a Label element in the OR UI model domain.
 * name property is pre-populated with initial text value coming from model
 * (that is before any potential update from linked sensor occurs).
 *
 * Provides a mechanism for clients to register and receive notifications when property values change.
 */
@interface ORLabel : ORWidget

/**
 * The current text value of this label.
 */
@property (strong, nonatomic, readonly) NSString *text;

/**
 * The current color of the text of this label.
 */
@property (strong, nonatomic, readonly) UIColor *textColor;

/**
 * The current font of the text of this label.
 */
@property (strong, nonatomic, readonly) UIFont *font;

@end