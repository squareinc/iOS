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

#import "ORWidget.h"

@class ORImage;
@class ORLabel;
@class ORNavigation;

/**
 * Model object representing an button element in the OR UI model domain.
 */
@interface ORButton : ORWidget

/**
 * Instruct the button that it has been pressed.
 *
 * Button will, based on its parameters, execute the appropriate action(s),
 * such as sending command to the controller (once or repeateadly)
 * or instruct the ORConsole to perform a navigation.
 */
- (void)press;

/**
 * Instruct the button that it has been released.
 *
 * Button will, based on its parameters, execute the appropriate action(s),
 * such as sending command to the controller (once or repeateadly)
 * or instruct the ORConsole to perform a navigation.
 */
- (void)depress;

/**
 * Label representing the text to be displayed on the button.
 * Can be nil if no test to be displayed.
 */
@property (nonatomic, strong, readonly) ORLabel *label;

/**
 * Image to be used for the released / default state of the button.
 */
@property (nonatomic, strong) ORImage *unpressedImage;

/**
 * Image to be used for the pressed state of the button.
 */
@property (nonatomic, strong) ORImage *pressedImage;

/**
 * Navigate object indicating what navigation should be conducted.
 * Can be nil if no navigation is triggered by the button.
 */
@property (nonatomic, strong) ORNavigation *navigation;

@end