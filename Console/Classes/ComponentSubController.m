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
#import "ComponentSubController.h"
#import "ORControllerClient/Component.h"
#import "LabelSubController.h"
#import "ORControllerClient/ORLabel.h"
#import "ImageSubController.h"
#import "ORControllerClient/ORImage.h"
#import "ButtonSubController.h"
#import "ORControllerClient/ORButton.h"
#import "SwitchSubController.h"
#import "ORControllerClient/ORSwitch.h"
#import "WebSubController.h"
#import "ORControllerClient/Web.h"
#import "ColorPickerSubController.h"
#import "ORControllerClient/ColorPicker.h"
#import "SliderSubController.h"
#import "ORControllerClient/Slider.h"

@interface ComponentSubController()

@property (nonatomic, readwrite, strong) Component *component;
@property (nonatomic, weak) ORControllerConfig *controller;
@property (nonatomic, weak) ImageCache *imageCache;

@end

@implementation ComponentSubController

static NSMutableDictionary *modelObjectToSubControllerClassMapping;

+ (void)initialize
{
    [super initialize];
    modelObjectToSubControllerClassMapping = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              [LabelSubController class], [ORLabel class],
                                              [ImageSubController class], [ORImage class],
                                              [ButtonSubController class], [ORButton class],
                                              [SwitchSubController class], [ORSwitch class],
                                              [WebSubController class], [Web class],
                                              [ColorPickerSubController class], [ColorPicker class],
                                              [SliderSubController class], [Slider class],
                                              nil];
}

- (id)initWithController:(ORControllerConfig *)aController imageCache:(ImageCache *)aCache component:(Component *)aComponent
{
    self = [super init];
    if (self) {
        self.controller = aController;
        self.component = aComponent;
        self.imageCache = aCache;
    }
    return self;
}

- (void)dealloc
{
    self.controller = nil;
    self.imageCache = nil;
}

+ (Class)subControllerClassForModelObject:(id)modelObject
{
    Class clazz = [modelObjectToSubControllerClassMapping objectForKey:[modelObject class]];
    return clazz?clazz:self;
}

@synthesize component;

@end