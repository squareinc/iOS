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
#import "ORModelObject.h"

@class ORNavigation;
@class ORImage;
@class ORLabel;

/**
 * Model object representing a TabBarItem element in the OR UI model domain.
 */
@interface ORTabBarItem : ORModelObject <NSCoding>

/**
 * Label representing the text to be displayed on the tab bar item.
 */
@property (nonatomic, strong, readonly) ORLabel *label;

/*
 * Image displayed on item.
 */
@property (nonatomic, strong, readonly) ORImage *image;

/**
 * Navigation to perform when item is tapped.
 */
@property (nonatomic, strong, readonly) ORNavigation *navigation;

@end