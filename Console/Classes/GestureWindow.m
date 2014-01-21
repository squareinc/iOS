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
#import "GestureWindow.h"
#import "ORControllerClient/Gesture.h"
#import "NotificationConstant.h"

@interface GestureWindow (Private)

- (void)showLoading;
- (void)hideLoading;

@end



/*
 * UIWindow to intercept touch events as gesture, this doesn't break the event delivery.
 *
 * When the iPhone detects a touch it determines the first responder for that event 
 * by recursively calling hitTest:withEvent: to descend down the tree of UIResponder 
 * objects in the application’s window. 
 * The first reponder is then sent the event and can either respond to it 
 * or pass it up the responder chain from view to view controller to parent view.
 * To detect gestures anywhere in the app so I chose to override sendEvent: in UIWindow. 
 * This allowed me to intercept touch events before they were sent to the first responder.
 * See also : http://developer.apple.com/iphone/library/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/EventHandling/EventHandling.html#//apple_ref/doc/uid/TP40007072-CH9-SW9
 */

@implementation GestureWindow

- (id)init {
	if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
		
		loading  = [[LoadingHUDView alloc] initWithTitle:@"Loading"];
		loading.center = self.center;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading) name:NotificationShowLoading object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading) name:NotificationHideLoading object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	}
	
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)showLoading {
	if (loading.superview != self) {
		[self addSubview:loading];
	}
	[loading startAnimating];
}

- (void)hideLoading {
	[loading stopAnimating];
	[loading removeFromSuperview];
}

@end


