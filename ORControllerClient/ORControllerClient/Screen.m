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
#import "Screen.h"
#import "Control.h"
#import "AbsoluteLayoutContainer.h"
#import "GridLayoutContainer.h"
#import "Definition.h"
#import "Gesture.h"

@interface Screen ()

@property (nonatomic, readwrite) int screenId;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSMutableArray *layouts;
@property (nonatomic, strong, readwrite) NSMutableArray *gestures;
@property (nonatomic, readwrite) BOOL landscape;
@property (nonatomic, readwrite) int inverseScreenId;

@end

@implementation Screen
 
- (id)initWithScreenId:(int)anId name:(NSString *)aName landscape:(BOOL)landscapeFlag inverseScreenId:(int)anInverseScreenId
{
    if (self = [super init]) {
		self.screenId = anId;
		self.name = aName;
		self.layouts = [NSMutableArray array];
		self.gestures = [NSMutableArray array];
		self.landscape = landscapeFlag;
		self.inverseScreenId = anInverseScreenId;
	}
	return self;
}

- (NSArray *)pollingComponentsIds {
	NSMutableSet *ids = [[NSMutableSet alloc] init];
	for (LayoutContainer *layout in self.layouts) {		
		[ids addObjectsFromArray:[layout pollingComponentsIds]];
	}
	return [ids allObjects];
}

- (int)screenIdForOrientation:(UIDeviceOrientation)orientation {
    if (self.inverseScreenId == 0) {
        return self.screenId;
    }
    return (self.landscape == UIInterfaceOrientationIsLandscape(orientation))?self.screenId:self.inverseScreenId;
}

- (ORGesture *)gestureForType:(ORGestureType)type
{
    for (ORGesture *g in self.gestures) {
        if (g.gestureType == type) {
            return g;
        }
    }
    return nil;
}

@synthesize screenId,name,background,layouts,gestures,landscape,inverseScreenId;

@end