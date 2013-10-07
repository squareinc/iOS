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
#import "LayoutContainerSubController.h"
#import "LayoutContainer.h"
#import "AbsoluteLayoutContainer.h"
#import "AbsoluteLayoutContainerSubController.h"
#import "GridLayoutContainer.h"
#import "GridLayoutContainerSubController.h"

@interface LayoutContainerSubController()

@property (nonatomic, assign) ORControllerConfig *controller;
@property (nonatomic, retain) LayoutContainer *layoutContainer;
@property (nonatomic, assign) ImageCache *imageCache;

@end

@implementation LayoutContainerSubController

- (id)initWithController:(ORControllerConfig *)aController imageCache:(ImageCache *)aCache layoutContainer:(LayoutContainer *)aLayoutContainer
{
    self = [super init];
    if (self) {
        self.controller = aController;
        self.layoutContainer = aLayoutContainer;
        self.imageCache = aCache;
    }    
    return self;
}

- (void)dealloc
{
    self.layoutContainer = nil;
    self.controller = nil;
    self.imageCache = nil;
    [super dealloc];
}

+ (Class)subControllerClassForModelObject:(id)modelObject
{
    if ([modelObject isKindOfClass:[AbsoluteLayoutContainer class]]) {
        return [AbsoluteLayoutContainerSubController class];
    } else if ([modelObject isKindOfClass:[GridLayoutContainer class]]) {
        return [GridLayoutContainerSubController class];
    }
    return self;
}

@synthesize layoutContainer;

@end