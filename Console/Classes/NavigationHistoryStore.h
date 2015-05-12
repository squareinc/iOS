/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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

@class ScreenReferenceStack;
@class Definition;

/**
 * A NavigationHistoryStore is responsible to store and retrieve the navigation history.
 * Different implementations of this protocol can choose the way persistence is implemented.
 */
@protocol NavigationHistoryStore <NSObject>

/**
 * Persists the given navigation history for the given model.
 *
 * @param history The navigation history to persist.
 * @param definition The model this navigation history relates to.
 */
- (void)persistHistory:(ScreenReferenceStack *)history forDefinition:(Definition *)definition;

/**
 * Retrieves from persistent store the navigation history for the given model.
 *
 * @param definition The model the navigation history relates to.
 *
 * @return ScreenReferenceStack the navigation history.
 */
- (ScreenReferenceStack *)retrieveHistoryForDefinition:(Definition *)definition;

@end
