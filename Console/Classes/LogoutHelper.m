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
#import "LogoutHelper.h"
#import "ServerDefinition.h"
#import "ViewHelper.h"
#import "ViewHelper.h"
#import "ControllerException.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

@interface LogoutHelper ()

@property (nonatomic, weak) ORConsoleSettingsManager *settingsManager;
@end


@implementation LogoutHelper

- (id)initWithConsoleSettingsManager:(ORConsoleSettingsManager *)aSettingsManager
{
    self = [super init];
    if (self) {
        self.settingsManager = aSettingsManager;
    }
    return self;
}

- (void)dealloc
{
    self.settingsManager = nil;
}

- (void)requestLogout {
    
    // Used to send POST request on logout "resource" (http://<controller address>:<controller port>/controller/logout)
    // But there is no session maintained with controller
    // And this call is not documented as part of the controller REST API
    
    // So don't do anything for now
}

@end
