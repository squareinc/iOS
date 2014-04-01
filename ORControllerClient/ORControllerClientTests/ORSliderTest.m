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

#import "ORSliderTest.h"
#import "ORSlider_Private.h"
#import "ORObjectIdentifier.h"

@implementation ORSliderTest

- (void)testSetValueWithinBounds
{
    ORSlider *slider = [[ORSlider alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] vertical:NO passive:NO thumbImageSrc:nil];
    slider.value = 10.0f;
    STAssertEquals(slider.value, 10.0f, @"Slider value should be set value");
}

- (void)testSetValueOutsideBoundsGetClipped
{
    ORSlider *slider = [[ORSlider alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] vertical:NO passive:NO thumbImageSrc:nil];
    slider.value = -10.0f;
    STAssertEquals(slider.value, 0.0f, @"Slider value should be minimum value when set with a value smaller than minimum");
    
    slider.value = 110.0f;
    STAssertEquals(slider.value, 100.0f, @"Slider value should be maximum value when set with a value greater than maximum");
}

- (void)testSetValueOnPassiveSliderShouldNotSetValue
{
    ORSlider *slider = [[ORSlider alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] vertical:NO passive:YES thumbImageSrc:nil];
    slider.value = 10.0f;
    STAssertEquals(slider.value, 0.0f, @"Slider value should not change (stay default) when trying to set value on passive slider");
}

@end