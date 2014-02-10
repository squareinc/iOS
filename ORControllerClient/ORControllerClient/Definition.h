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
#import <UIKit/UIKit.h>

@class TabBar;
@class ORLabel;
@class Group;
@class Screen;
@class LocalController;

@class ORSensorRegistry;
@class ORController;
@class ORObjectIdentifier;
@class ORButton;

@protocol ORConsole;

/**
 * This class is responsible for storing some models data (groups, screens, labels, tabBar, images and local controllers)
 */
@interface Definition : NSObject

/**
 * Clear stored models data(groups, screens, labels and tabBar).
 */
- (void)clearPanelXMLData;

/**
 * Add image name to a array for downloading images into image cache.
 */
- (void)addImageName:(NSString *)imageName;

/**
 * Get a group instance with group id.
 */
- (Group *)findGroupById:(int)groupId;

/**
 * Get a screen instance with screen id.
 */
- (Screen *)findScreenById:(int)screenId;

/**
 * Add a group instance for caching.
 */
- (void)addGroup:(Group *)group;

/**
 * Add a screen instance for caching.
 */
- (void)addScreen:(Screen *)screen;

/**
 * Add a label instance for caching.
 */
- (void) addLabel:(ORLabel *)label;

/**
 * Get a label instance with label id.
 */
- (ORLabel *)findLabelById:(int)labelId;

- (ORLabel *)findLabelByIdentifier:(ORObjectIdentifier *)identifier;



- (void)sendPressCommandForButton:(ORButton *)sender;
- (void)sendShortReleaseCommandForButton:(ORButton *)sender;
- (void)sendLongPressCommandForButton:(ORButton *)sender;
- (void)sendLongReleaseCommandForButton:(ORButton *)sender;


@property (nonatomic, strong, readonly) NSMutableArray *groups;
@property (nonatomic, strong, readonly) NSMutableArray *screens;

@property (nonatomic, strong, readonly) NSSet *labels;

@property (nonatomic, strong) TabBar *tabBar;
@property (nonatomic, strong) LocalController *localController;
@property (nonatomic, strong, readonly) NSMutableArray *imageNames;

@property (nonatomic, strong, readonly) ORSensorRegistry *sensorRegistry;

/**
 * Controller the Definition is attached to.
 * Values of widgets are only updated when the Definition is attached to a controller.
 * Property is nil when Definition is not attached to any controller.
 */
@property (nonatomic, weak, readonly) ORController *controller;

/**
 * Client application using this Definition.
 */
@property (nonatomic, weak) NSObject<ORConsole> *console;

@end