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
#import "ORWidget.h"

/**
 * Name of notification indicating that label text value has been changed by an external event (sensor update).
 */
extern NSString const *kORLabelTextValueChanged;

// TODO: In current sample application, we're using KVO for this purpose
// Would adding this notification provide any value ? Simpler code ?
// Using central notification center to register/unregister might be simpler for our clients.

/**
 * Model object representing a Label element in the OR UI model domain.
 *
 * Provides a mechanism for clients to register and receive notifications when property values change.
 */
@interface ORLabel : ORWidget

- (id)initWithIdentifier:(ORObjectIdentifier *)anIdentifier text:(NSString *)someText;

// Q : should we have an id ? If yes, encapsulate in ORObjectIdentifier class -> can change from int to something meaningfull later

/**
 * The current text value of this label.
 */
@property (strong, nonatomic) NSString *text;

/**
 * Indicates if any property of this label can be dynamically updated by a sensor linked to it.
 */
@property (nonatomic, readonly) BOOL isDynamic;

@end
