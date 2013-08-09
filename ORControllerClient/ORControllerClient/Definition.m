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
#import "Definition.h"
#import "Label.h"
#import "Group.h"
#import "Screen.h"

#import "ORLabel.h"

@interface Definition ()

@property (nonatomic, strong, readwrite) NSMutableArray *groups;
@property (nonatomic, strong, readwrite) NSMutableArray *screens;

/**
 * All the labels in this panel configuration
 *
 * Implementation note: this is currently filled in by parser during parsing
 */
@property (nonatomic, strong, readwrite) NSMutableArray *legacyLabels;

/**
 * ORLabel instances, maintained in // with legacyLabels version
 */
@property (nonatomic, strong) NSMutableArray *_labels;

@property (nonatomic, strong, readwrite) NSMutableArray *imageNames;

@end

@implementation Definition

- (id)init
{			
    self = [super init];
    if (self) {
        self.groups = [NSMutableArray array];
		self.screens = [NSMutableArray array];
		self.legacyLabels = [NSMutableArray array];
        self._labels = [NSMutableArray array];
		self.imageNames = [NSMutableArray array];
	}
	return self;
}

- (Group *)findGroupById:(int)groupId {
	for (Group *g in self.groups) {
		if (g.groupId == groupId) {
			return g;			
		}
	}
	return nil;
}

- (Screen *)findScreenById:(int)screenId {
	for (Screen *tempScreen in self.screens) {
		if (tempScreen.screenId == screenId) {
			NSLog(@"find screen screenId %d", screenId);
			return tempScreen;
		}
	}
	return nil;
}

- (void)addGroup:(Group *)group {
	for (int i = 0; i < self.groups.count; i++) {
		Group *tempGroup = [self.groups objectAtIndex:i];
		if (tempGroup.groupId == group.groupId) {
			[self.groups replaceObjectAtIndex:i withObject:group];
			return;
		}
	}
	[self.groups addObject:group];
}

- (void)addScreen:(Screen *)screen {
	for (int i = 0; i < self.screens.count; i++) {
		Screen *tempScreen = [self.screens objectAtIndex:i];
		if (tempScreen.screenId == screen.screenId) {
			[self.screens replaceObjectAtIndex:i withObject:screen];
			return;
		}
	}
	[self.screens addObject:screen];
}

- (void) addLabel:(Label *)label {
	for (int i = 0; i < self.legacyLabels.count; i++) {
		Label *tempLabel = [self.legacyLabels objectAtIndex:i];
		if (tempLabel.componentId == label.componentId) {
			[self.legacyLabels replaceObjectAtIndex:i withObject:label];
            [self._labels replaceObjectAtIndex:i withObject:[[ORLabel alloc] initWithText:label.text]];
			return;
		}
	}
	[self.legacyLabels addObject:label];
    [self._labels addObject:[[ORLabel alloc] initWithText:label.text]];
}

- (Label *)findLabelById:(int)labelId {
	for (Label *tempLabel in self.legacyLabels) {
		if (tempLabel.componentId == labelId) {
			return tempLabel;
		}
	}
	return nil;
}

- (void)addImageName:(NSString *)imageName {
	for (NSString *name in self.imageNames) {
		// avoid duplicated
		if ([name isEqualToString:imageName]) {
			return;
		}
	}
	if (imageName) {
		[[self imageNames] addObject:imageName];	
	}
}

- (void)clearPanelXMLData
{
    [self.groups removeAllObjects];
    [self.screens removeAllObjects];
    [self.legacyLabels removeAllObjects];
    [self._labels removeAllObjects];
    [self.imageNames removeAllObjects];
    self.tabBar = nil;
}

- (NSSet *)labels
{
    return [NSSet setWithArray:self._labels];
}

@synthesize groups, screens, legacyLabels, tabBar, localController, imageNames;

@end