/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "ColorPickerSubController.h"
#import "ORControllerClient/ORColorPicker.h"
#import "ORControllerClient/ORImage.h"
#import "ColorPickerImageView.h"
#import "ImageCache.h"

@interface ColorPickerSubController()

@property (nonatomic, readwrite, strong) UIView *view;
@property (weak, nonatomic, readonly) ORColorPicker *colorPicker;
@property (nonatomic, weak) ImageCache *imageCache;

@end

@implementation ColorPickerSubController

- (id)initWithController:(ORControllerConfig *)aController imageCache:(ImageCache *)aCache component:(ORWidget *)aComponent
{
    self = [super initWithController:aController imageCache:aCache component:aComponent];
    if (self) {
        ColorPickerImageView *imageView = [[ColorPickerImageView alloc] initWithImage:nil];
        UIImage *uiImage = [self.imageCache getImageNamed:self.colorPicker.image.src finalImageAvailable:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }];
        if (uiImage) {
            imageView.image = uiImage;
        }
        imageView.pickedColorDelegate = self;
        self.view = imageView;
    }
    return self;
}

- (ORColorPicker *)colorPicker
{
    return (ORColorPicker *)self.component;
}

// Send picker command with color value to controller server.
- (void)pickedColor:(UIColor *)color
{
    [self.colorPicker sendColor:color];
}

@synthesize view;

@end