/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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
#import "ORScreenOrGroupReference.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORObjectIdentifier.h"
#import "ORControllerClient/ORGroup.h"
#import "ORControllerClient/ORScreen.h"
#import "ScreenReferenceStack.h"
#import "NavigationHistoryUserDefaultsStore.h"

@interface NavigationManager ()

@property (nonatomic, strong) Definition *definition;

@property (nonatomic, strong) ScreenReferenceStack *navigationHistory;

@property (nonatomic, strong) NSObject <NavigationHistoryStore> *navigationHistoryStore;

@end

@implementation NavigationManager

- (instancetype)initWithDefinition:(Definition *)aDefinition
{
    return [self initWithDefinition:aDefinition navigationHistoryStore:nil];
}

- (instancetype)initWithDefinition:(Definition *)aDefinition navigationHistoryStore:(NSObject <NavigationHistoryStore> *)store
{
    self = [super init];
    if (self) {
        if (aDefinition) {
            self.definition = aDefinition;
        
            // Should it listen for changes on definition e.g. groups and screens ?
            // This way could validate the navigation
        
         
            if (store) {
                self.navigationHistoryStore = store;
            } else {
                // By default, use a user defaults store
                self.navigationHistoryStore = [[NavigationHistoryUserDefaultsStore alloc] init];
            }
            
            self.navigationHistory = [self.navigationHistoryStore retrieveHistoryForDefinition:self.definition];
        } else {
            self = nil;
        }
    }
    return self;
}

// Methods will compute next screen reference or nil if navigation not possible
// Will push on stack if possible

- (ORScreenOrGroupReference *)navigateToGroup:(ORGroup *)group toScreen:(ORScreen *)screen
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
        ORScreenOrGroupReference *next = [[ORScreenOrGroupReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:0]).identifier];
        [self.navigationHistory push:next];
        [self.navigationHistoryStore persistHistory:self.navigationHistory forDefinition:self.definition];
        return next;
    } else {
        // Requested screen does not exist in group, don't navigate
        if ([group.screens indexOfObject:screen] == NSNotFound) {
            return nil;
        }
        ORScreenOrGroupReference *next = [[ORScreenOrGroupReference alloc] initWithGroupIdentifier:group.identifier screenIdentifier:screen.identifier];
        [self.navigationHistory push:next];
        [self.navigationHistoryStore persistHistory:self.navigationHistory forDefinition:self.definition];
        return next;
    }
    return nil;
}

- (ORScreenOrGroupReference *)navigateToPreviousScreen
{
    ORScreenOrGroupReference *current = [self currentScreenReference];
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
        ORScreenOrGroupReference *next = [[ORScreenOrGroupReference alloc] initWithGroupIdentifier:current.groupIdentifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:index]).identifier];
        [self.navigationHistory push:next];
        [self.navigationHistoryStore persistHistory:self.navigationHistory forDefinition:self.definition];
        return next;
    }
    return nil;
}

- (ORScreenOrGroupReference *)navigateToNextScreen
{
    ORScreenOrGroupReference *current = [self currentScreenReference];
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
        ORScreenOrGroupReference *next = [[ORScreenOrGroupReference alloc] initWithGroupIdentifier:current.groupIdentifier screenIdentifier:((ORScreen *)[group.screens objectAtIndex:index]).identifier];
        [self.navigationHistory push:next];
        [self.navigationHistoryStore persistHistory:self.navigationHistory forDefinition:self.definition];
        return next;
    }
    return nil;
}

- (ORScreenOrGroupReference *)back
{
    // Top is current screen, get rid of it
    [self.navigationHistory pop];

    [self.navigationHistoryStore persistHistory:self.navigationHistory forDefinition:self.definition];
    
    // TODO: validate that top is still a valid destination
    return [self.navigationHistory top];
}

- (ORScreenOrGroupReference *)currentScreenReference
{
    return [self.navigationHistory top];
}

@synthesize definition;

@end