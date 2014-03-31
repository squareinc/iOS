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

#import "ORScreen_Private.h"
#import "ORWidget_Private.h"

@interface ORScreen ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, readwrite) ORScreenOrientation orientation;
@property (nonatomic, strong, readwrite) NSMutableArray *_layouts;
@property (nonatomic, strong, readwrite) NSMutableArray *_gestures;

@end

@implementation ORScreen

- (instancetype)initWithScreenIdentifier:(ORObjectIdentifier *)anIdentifier
                          name:(NSString *)aName
                   orientation:(ORScreenOrientation)anOrientation
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.name = aName;
        self.orientation = anOrientation;
        self._layouts = [NSMutableArray array];
        self._gestures = [NSMutableArray array];
    }
    return self;
}

- (ORGesture *)gestureForType:(ORGestureType)type
{
    for (ORGesture *gesture in self.gestures) {
        if (gesture.gestureType == type) {
            return gesture;
        }
    }
    return nil;
}

- (ORScreen *)screenForOrientation:(ORScreenOrientation)anOrientation
{
    if (!self.rotatedScreen) {
        return self;
    }
    return (self.orientation == anOrientation)?self:self.rotatedScreen;
}

- (void)addLayout:(ORLayoutContainer *)layout
{
    [self._layouts addObject:layout];
}

- (NSArray *)layouts
{
    return [NSArray arrayWithArray:self._layouts];
}

- (void)addGesture:(ORGesture *)gesture
{
    if (![[self._gestures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"identifier == %@ || gestureType == %d",
                                                       gesture.identifier, gesture.gestureType]] count]) {
        [self._gestures addObject:gesture];
    }
}

- (NSArray *)gestures
{
    return [NSArray arrayWithArray:self._gestures];
}

@end