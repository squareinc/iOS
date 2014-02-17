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

/**
 * Model object representing a switch element in the OR UI model domain.
 */
@interface ORSwitch : ORWidget

/**
 * Image to be used for the on state of the switch.
 */
@property (nonatomic, strong) ORImage *onImage;

/**
 * Image to be used for the off state of the switch.
 */
@property (nonatomic, strong) ORImage *offImage;

/**
 * State of the switch.
 * This property is readonly, use the toggle, on and off methods to change the state.
 */
@property (nonatomic, readonly) BOOL state;

/**
 * Toggles the current switch, going from on to off or off to on depending on its current state.
 * The appropriate command is sent to the controller.
 */
- (void)toggle;

/**
 * Sets to switch to the on state.
 * The appropriate command is sent to the controller.
 *
 * If the switch state is already on, this method does nothing.
 */
- (void)on;

/**
 * Sets to switch to the off state.
 * The appropriate command is sent to the controller.
 *
 * If the switch state is already off, this method does nothing.
 */
- (void)off;

@end