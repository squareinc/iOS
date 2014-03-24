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

#import <UIKit/UIKit.h>
#import "ORWidget.h"

@class ORLabel;

/**
 * Model object representing an Image element in the OR UI model domain.
 */
@interface ORImage : ORWidget

- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier name:(NSString *)aName;

/**
 * The name of the image.
 */
@property (strong, nonatomic) NSString *name;

/**
 * The alternate text label that can be used in place of the image.
 */
@property (nonatomic, strong) ORLabel *label;

/**
 * Indicates if any property of this image can be dynamically updated by a sensor linked to it.
 */
@property (nonatomic, readonly) BOOL isDynamic;

@end