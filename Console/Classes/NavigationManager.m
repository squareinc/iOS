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

#import "NavigationManager.h"
#import "ScreenReference.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORObjectIdentifier.h"
#import "ORControllerClient/ORGroup.h"
#import "ORControllerClient/ORScreen.h"
#import "ScreenReferenceStack.h"

@interface NavigationManager ()

@property (nonatomic, strong) Definition *definition;

@property (nonatomic, strong) ScreenReferenceStack *navigationHistory;

@end

@implementation NavigationManager

- (instancetype)initWithDefinition:(Definition *)aDefinition
{
    self = [super init];
    if (self) {
        self.definition = aDefinition;
        
        // Should it listen for changes on definition e.g. groups and screens ?
        // This way could validate the navigation
        
        [self loadHistoryForDefinition];
    }
    return self;
}

// Methods will compute next screen reference or nil if navigation not possible
// Will push on stack if possible

- (ScreenReference *)navigateToGroup:(ORGroup *)group toScreen:(ORScreen *)screen
{
    // Requested group does not exist, don't navigate
    if ([self.definition.groups indexOfObject:group] == NSNotFound) {
        return nil;
    }
    if (!screen) {
        // No specific screen requested, pick first in group or don't navigate if group contains no screen
        if (![group.screens count]) {
            return nil;
        }
        ScreenReference *next = [[ScreenReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:0]).identifier];
        [self.navigationHistory push:next];
        [self persist];
        return next;
    } else {
        // Requested screen does not exist in group, don't navigate
        if ([group.screens indexOfObject:screen] == NSNotFound) {
            return nil;
        }
        ScreenReference *next = [[ScreenReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:screen.identifier];
        [self.navigationHistory push:next];
        [self persist];
        return next;
    }
    return nil;
}

- (ScreenReference *)navigateToPreviousScreen
{
    ScreenReference *current = [self currentScreenReference];
    ORGroup *group = [self.definition findGroupByIdentifier:current.groupIdentifier];
    ORScreen *screen = [group findScreenByIdentifier:current.screenIdentifier];
    NSUInteger index = [group.screens indexOfObject:screen];
    if (!index) {
        // Already at first screen, no previous one
        return nil;
    }
    if (index == NSNotFound) {
        // Current screen not found in group, go to first screen as fallback
        index = 0;
    } else {
        index--;
    }
    if (index < [group.screens count]) {
        ScreenReference *next = [[ScreenReference alloc] initWithGroupIdentifier:current.groupIdentifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:index]).identifier];
        [self.navigationHistory push:next];
        [self persist];
        return next;
    }
    return nil;
}

- (ScreenReference *)navigateToNextScreen
{
    ScreenReference *current = [self currentScreenReference];
    ORGroup *group = [self.definition findGroupByIdentifier:current.groupIdentifier];
    ORScreen *screen = [group findScreenByIdentifier:current.screenIdentifier];
    NSUInteger index = [group.screens indexOfObject:screen];
    if (index >= [group.screens count]) {
        // Already at last screen, no next one
        return nil;
    }
    if (index == NSNotFound) {
        // Current screen not found in group, go to first screen as fallback
        index = 0;
    } else {
        index++;
    }
    if (index < [group.screens count]) {
        ScreenReference *next = [[ScreenReference alloc] initWithGroupIdentifier:current.groupIdentifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:index]).identifier];
        [self.navigationHistory push:next];
        [self persist];
        return next;
    }
    return nil;
}

- (ScreenReference *)back
{
    // Top is current screen, get rid of it
    [self.navigationHistory pop];

    [self persist];
    
    // TODO: validate that top is still a valid destination
    return [self.navigationHistory top];
}

- (ScreenReference *)currentScreenReference
{
    return [self.navigationHistory top];
}

// Loads history for current definition from persistence cache
- (void)loadHistoryForDefinition
{
    self.navigationHistory = [[ScreenReferenceStack alloc] initWithCapacity:50];

    // In current version, only last group / screen id are saved,
    // so restart history from there
    
    ScreenReference *startReference = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"lastGroupId"]) {
		ORObjectIdentifier *lastGroupIdentifier = [[ORObjectIdentifier alloc] initWithStringId:[userDefaults objectForKey:@"lastGroupId"]];
        ORGroup *group = [self.definition findGroupByIdentifier:lastGroupIdentifier];
        if (!group) {
            startReference = [self createValidStartReference];
        } else {
            if ([userDefaults objectForKey:@"lastScreenId"]) {
                ORObjectIdentifier *lastScreenIdenfitier = [[ORObjectIdentifier alloc] initWithStringId:[userDefaults objectForKey:@"lastScreenId"]];
                ORScreen *screen = [group findScreenByIdentifier:lastScreenIdenfitier];
                if (!screen) {
                    startReference = [self createValidStartReferenceStartingInGroup:group];
                } else {
                    startReference = [[ScreenReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:screen.identifier];
                }
            } else {
                startReference = [self createValidStartReferenceStartingInGroup:group];
            }
        }
    } else {
        startReference = [self createValidStartReference];
    }
    if (startReference) {
        [self.navigationHistory push:startReference];
    }
}

/**
 * Finds the first group with at least one screen in the current definition.
 */
- (ScreenReference *)createValidStartReference
{
    for (ORGroup *group in self.definition.groups) {
        for (ORScreen *screen in group.screens) {
            return [[ScreenReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:screen.identifier];
        }
    }
    return nil;
}

- (ScreenReference *)createValidStartReferenceStartingInGroup:(ORGroup *)group
{
    for (ORScreen *screen in group.screens) {
        return [[ScreenReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:screen.identifier];
    }
    return [self createValidStartReference];
}

- (void)persist
{
    ScreenReference *current = [self currentScreenReference];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[current.groupIdentifier stringValue] forKey:@"lastGroupId"];
	[userDefaults setObject:[current.screenIdentifier stringValue] forKey:@"lastScreenId"];
	NSLog(@"Saved : groupID %@, screenID %@", [userDefaults objectForKey:@"lastGroupId"], [userDefaults objectForKey:@"lastScreenId"]);
}

@synthesize definition;

@end