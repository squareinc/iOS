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
 *
 * Provides a mechanism for clients to register and receive notifications when property values change.
 */
@interface ORLabel : ORWidget

- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier text:(NSString *)someText;

/**
 * The current text value of this label.
 */
@property (strong, nonatomic) NSString *text;

/**
 * The current color of the text of this label.
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 * The current font of the text of this label.
 */
@property (strong, nonatomic) UIFont *font;

/**
 * Indicates if any property of this label can be dynamically updated by a sensor linked to it.
 */
@property (nonatomic, readonly) BOOL isDynamic;

@end
