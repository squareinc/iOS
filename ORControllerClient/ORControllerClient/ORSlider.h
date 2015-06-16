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
 * Model object representing a slider element in the OR UI model domain.
 */
@interface ORSlider : ORWidget <NSCoding>

/**
 * Indicates if the slider should be drawn vertically or horizontally.
 */
@property(nonatomic, readonly) BOOL vertical;

/**
 * Indicates if the slider is passive, only indicating a value
 * or if it can be manipulated by the user.
 */
@property(nonatomic, readonly) BOOL passive;

/**
 * Minimum value of the slider, with the thumb at left or bottom position.
 */
@property(nonatomic, readonly) float minValue;

/**
 * Maximum value of the slider, with the thumb at the right or top position.
 */
@property(nonatomic, readonly) float maxValue;

/**
 * Image to be used to draw the thumb of the slider.
 */
@property(nonatomic, strong, readonly) ORImage *thumbImage;

/**
 * Image to be used to draw the minimum icon of the slider.
 * That is to the left of the track for an horizontal slider
 * and at the bottom of the track for a vertical slider.
 */
@property(nonatomic, strong, readonly) ORImage *minImage;

/**
 * Image to be used to draw the track before the slider thumb.
 */
@property(nonatomic, strong, readonly) ORImage *minTrackImage;

/**
 * Image to be used to draw the maximum icon of the slider.
 * That is to the right of the track for an horizontal slider
 * and at the top of the track for a vertical slider.
 */
@property(nonatomic, strong, readonly) ORImage *maxImage;

/**
 * Image to be used to draw the track after the slider thumb.
 */
@property(nonatomic, strong, readonly) ORImage *maxTrackImage;

/**
 * Current value of the slider.
 * 
 * Setting this value sends the appropriate command to the controller.
 * The set value is clipped within the slider bounds before being sent.
 */
@property (nonatomic) float value;

@end