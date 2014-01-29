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

@class ORImage;

/**
 * Enumeration indicating how an image should repeat to fill the screen.
 */
typedef NS_ENUM(NSInteger, ORBackgroundRepeat) {
    ORBackgroundRepeatRepeat, // Repeat on both axis
    ORBackgroundRepeatNoRepeat, // Do not repeat
    ORBackgroundRepeatRepeatX, // Repeat along X axis only
    ORBackgroundRepeatRepeatY // Repeat along Y axis only
};

/**
 * Enumaration indicating the unit of a certain measure.
 */
typedef NS_ENUM(NSInteger, ORWidgetUnit) {
    ORWidgetUnitNotDefined, // Indicates associated value is not defined
    ORWidgetUnitPercentage, // Percentage = relative
    ORWidgetUnitLength // Absolute, unit is defined as point
};

/**
 * Model object representing the background element in the OR UI model domain.
 *
 * This provides the information on how the background of a screen is rendered.
 * Currently this includes an image and how it is positioned/sized within the screen.
 * Those options are modeled similar to CCS3 specifications.
 */
@interface ORBackground : NSObject

/**
 * Image to use to fill the background.
 */
@property (nonatomic, strong) ORImage *image;

/**
 * Repetition for the image if require to fill the background.
 * The default is not to repeat.
 */
@property (nonatomic) ORBackgroundRepeat repeat;

/**
 * Position of the image. positionUnit indicates the unit of this property.
 */
@property (nonatomic) CGPoint position;

/**
 * Unit in which position property is expressed.
 * ORWidgetUnitPercentage indicates a relative position.
 *
 * Defaults to ORWidgetUnitNotDefined.
 */
@property (nonatomic) ORWidgetUnit positionUnit;

/**
 * Size of the image. sizeUnit indicates the unit of this property.
 * Having this property not specified (unit ORWidgetUnitNotDefined)
 * indicates that image size should be used (i.e. that the image should not be resized).
 */
@property (nonatomic) CGSize size;

/**
 * Unit in which size property is expressed.
 * ORWidgetUnitPercentage indicates a size relative to its container.
 * ORWidgetUnitNotDefined indicates size has not been defined.
 *
 * Defaults to ORWidgetUnitNotDefined.
 */
@property (nonatomic) ORWidgetUnit sizeUnit;

@end