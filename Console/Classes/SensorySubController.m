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
#import "SensorySubController.h"
#import "ORControllerClient/SensorComponent.h"
#import "NotificationConstant.h"
#import "ORControllerClient/ORLabel.h"
#import "ORControllerClient/ORImage.h"
#import "ORControllerClient/ORSwitch.h"
#import "ORControllerClient/ORWebView.h"

@interface SensorySubController()

- (void)addPollingNotificationObserver;

@end

@implementation SensorySubController

- (id)initWithController:(ORControllerConfig *)aController  imageCache:(ImageCache *)aCache component:(Component *)aComponent
{
    self = [super initWithController:aController imageCache:aCache component:aComponent];
    if (self) {
        [self addPollingNotificationObserver];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Add notification observer for polling
- (void)addPollingNotificationObserver
{
    /* TODO: remove later, whole polling notification should be reviewed / go away */
    if ([self.component isKindOfClass:[ORLabel class]] || ([self.component isKindOfClass:[ORImage class]]) || ([self.component isKindOfClass:[ORSwitch class]] || [self.component isKindOfClass:[ORWebView class]])) {
        return;
    }
        
	int sensorId = ((SensorComponent *)self.component).sensorId;
    if (sensorId > 0 ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:NotificationPollingStatusIdFormat, sensorId] object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPollingStatus:) name:[NSString stringWithFormat:NotificationPollingStatusIdFormat, sensorId] object:nil];
	}
}

- (void)setPollingStatus:(NSNotification *)notification
{
    // Do nothing here, subclasses interested in processing the sensor update will implement appropriately
}

@end
