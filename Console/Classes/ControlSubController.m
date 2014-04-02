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
#import "ControlSubController.h"
#import "ORControllerClient/LocalController.h"
#import "ORControllerClient/LocalCommand.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"
#import "ORControllerClient/Definition.h"
#import "AppDelegate.h"
#import "ClientSideRuntime.h"
#import "ORControllerProxy.h"

@interface ControlSubController ()

- (NSArray *)localCommandsForCommandType:(NSString *)commandType;

@property (nonatomic, weak) ORControllerConfig *controller;

@end

@implementation ControlSubController

- (void)sendCommandRequest:(NSString *)commandType {
    NSLog(@"commandType %@", commandType);

	// Check for local command first
	NSArray *localCommands = [self localCommandsForCommandType:commandType];
    if (localCommands && ([localCommands count] > 0)) {
        [self.controller.clientSideRuntime executeCommands:localCommands commandType:commandType];
	} else {
        @throw [[NSException alloc] initWithName:NSInternalInconsistencyException
                                          reason:@"Only local commands should be handeld this way"
                                        userInfo:@{ @"commandType" : commandType }];
	}
}

- (NSArray *)localCommandsForCommandType:(NSString *)commandType
{
	return [self.controller.definition.localController commandsForComponentIdentifier:self.component.identifier action:commandType];
}

@end