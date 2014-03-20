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
#import "Group.h"
#import "ORScreen.h"
#import "ORSensorRegistry.h"
#import "ORController.h"
#import "ORObjectIdentifier.h"
#import "ORLabel.h"
#import "ORImage.h"

// Import of private is required even if not directly use to make sure setController: is synthetized
#import "Definition_Private.h"

@interface Definition ()

@property (nonatomic, strong, readwrite) NSMutableArray *groups;
@property (nonatomic, strong, readwrite) NSMutableArray *screens;

/**
 * All the labels in this panel configuration
 *
 * Implementation note: this is currently filled in by parser during parsing
 */
@property (nonatomic, strong) NSMutableArray *_labels;

@property (nonatomic, strong) NSMutableArray *_images;
@property (nonatomic, strong) NSMutableArray *_buttons;
@property (nonatomic, strong) NSMutableArray *_switches;
@property (nonatomic, strong) NSMutableArray *_sliders;
@property (nonatomic, strong) NSMutableArray *_colorPickers;
@property (nonatomic, strong) NSMutableArray *_webViews;

@property (nonatomic, strong, readwrite) ORSensorRegistry *sensorRegistry;

@property (nonatomic, strong, readwrite) NSMutableArray *imageNames;

@end

@implementation Definition

- (id)init
{			
    self = [super init];
    if (self) {
        self.groups = [NSMutableArray array];
		self.screens = [NSMutableArray array];
        self._labels = [NSMutableArray array];
        self._images = [NSMutableArray array];
        self._buttons = [NSMutableArray array];
        self._switches = [NSMutableArray array];
        self._sliders = [NSMutableArray array];
        self._colorPickers = [NSMutableArray array];
        self._webViews = [NSMutableArray array];
		self.imageNames = [NSMutableArray array];
        self.sensorRegistry = [[ORSensorRegistry alloc] init];
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

- (ORGroup *)findGroupByIdentifier:(ORObjectIdentifier *)groupIdentifier
{
    // TODO: re-implement with appropriate class
    Group *g = [self findGroupById:[[groupIdentifier stringValue] intValue]];
    return g;
}

- (ORScreen *)findScreenByIdentifier:(ORObjectIdentifier *)screenIdentifier
{
	for (ORScreen *tempScreen in self.screens) {
        if ([tempScreen.identifier isEqual:screenIdentifier]) {
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

- (void)addScreen:(ORScreen *)screen {
	for (int i = 0; i < self.screens.count; i++) {
		ORScreen *tempScreen = [self.screens objectAtIndex:i];
		if ([tempScreen.identifier isEqual:screen.identifier]) {
			[self.screens replaceObjectAtIndex:i withObject:screen];
			return;
		}
	}
	[self.screens addObject:screen];
}

- (void)addLabel:(ORLabel *)label {
    // TODO: why can this happen, adding multiple time a label with same id ??? -> document or assert can't happen
	for (int i = 0; i < self._labels.count; i++) {
		ORLabel *tempLabel = [self._labels objectAtIndex:i];
		if ([tempLabel.identifier isEqual:label.identifier]) {
            [self._labels replaceObjectAtIndex:i withObject:label];
            
            // TODO: handle sensorRegistry operation for this specific case ???
            
			return;
		}
	}
    [self._labels addObject:label];
}

- (ORLabel *)findLabelById:(int)labelId
{
    return [self findLabelByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:labelId]];
}

- (ORLabel *)findLabelByIdentifier:(ORObjectIdentifier *)identifier
{
	for (ORLabel *tempLabel in self._labels) {
		if ([tempLabel.identifier isEqual:identifier]) {
			return tempLabel;
		}
	}
	return nil;
}

- (void)addImage:(ORImage *)image
{
    [self._images addObject:image];
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

- (void)addButton:(ORButton *)button
{
    [self._buttons addObject:button];
}

- (void)addSwitch:(ORSwitch *)sswitch
{
    [self._switches addObject:sswitch];
}

- (void)addSlider:(ORSlider *)slider
{
    [self._sliders addObject:slider];
}

- (void)addColorPicker:(ORColorPicker *)colorPicker
{
    [self._colorPickers addObject:colorPicker];
}

- (void)addWebView:(ORWebView *)webView
{
    [self._webViews addObject:webView];
}

- (void)clearPanelXMLData
{
    [self.groups removeAllObjects];
    [self.screens removeAllObjects];
    [self._labels removeAllObjects];
    [self.sensorRegistry clearRegistry];
    [self.imageNames removeAllObjects];
    [self._images removeAllObjects];
    [self._buttons removeAllObjects];
    [self._switches removeAllObjects];
    [self._sliders removeAllObjects];
    [self._colorPickers removeAllObjects];
    [self._webViews removeAllObjects];
    self.tabBar = nil;
}

- (NSSet *)labels
{
    return [NSSet setWithArray:self._labels];
}

- (NSSet *)images
{
    return [NSSet setWithArray:self._images];
}

- (NSSet *)buttons
{
    return [NSSet setWithArray:self._buttons];
}

- (NSSet *)switches
{
    return [NSSet setWithArray:self._switches];
}

- (NSSet *)sliders
{
    return [NSSet setWithArray:self._sliders];
}

- (NSSet *)colorPickers
{
    return [NSSet setWithArray:self._colorPickers];
}

- (NSSet *)webViews
{
    return [NSSet setWithArray:self._webViews];
}

- (void)sendPressCommandForButton:(ORButton *)sender
{
    [self.controller sendPressCommandForButton:sender];
}

- (void)sendShortReleaseCommandForButton:(ORButton *)sender
{
    [self.controller sendShortReleaseCommandForButton:sender];
}

- (void)sendLongPressCommandForButton:(ORButton *)sender
{
    [self.controller sendLongPressCommandForButton:sender];
}

- (void)sendLongReleaseCommandForButton:(ORButton *)sender
{
    [self.controller sendLongReleaseCommandForButton:sender];
}

- (void)sendOnForSwitch:(ORSwitch *)sender
{
    [self.controller sendOnForSwitch:sender];
}

- (void)sendOffForSwitch:(ORSwitch *)sender
{
    [self.controller sendOffForSwitch:sender];
}

- (void)sendValue:(float)value forSlider:(ORSlider *)sender
{
    [self.controller sendValue:value forSlider:sender];
}

- (void)performGesture:(ORGesture *)sender
{
    [self.controller performGesture:sender];
}

@synthesize groups, screens, tabBar, localController, imageNames, controller;

@end