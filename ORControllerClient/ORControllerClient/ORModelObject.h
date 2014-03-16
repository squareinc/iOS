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

#import <Foundation/Foundation.h>
#import "Component.h"

@class Definition;

/**
 * Abstract parent class of all model objects in OR model.
 *
 * Provides access to the definition all objects belong to.
 */
@interface ORModelObject : Component /* temporary while transitoning between legacy and new object model, should be NSObject */

// TODO: this is using legacy object, update to current model when ready

/**
 * Definition the widget belongs to.
 */
@property (nonatomic, weak) Definition *definition;

@end