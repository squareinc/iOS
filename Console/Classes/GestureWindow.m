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
#import "LoadingHUDView.h"
#import "NotificationConstant.h"

@interface GestureWindow ()

- (void)showLoading;
- (void)hideLoading;

@property (nonatomic, strong) LoadingHUDView *loading;

@end

/*
 * UIWindow with additional loading indicator display.
 *
 * The name GestureWindow is historical, as gesture recognition was previously implemented here (IPHONE-191).
 */

@implementation GestureWindow

- (id)init
{
	if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
		self.loading  = [[LoadingHUDView alloc] initWithTitle:@"Loading"];
		self.loading.center = self.center;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading) name:NotificationShowLoading object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading) name:NotificationHideLoading object:nil];

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	}
	
	return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)showLoading
{
	if (self.loading.superview != self) {
		[self addSubview:self.loading];
	}
	[self.loading startAnimating];
}

- (void)hideLoading
{
	[self.loading stopAnimating];
	[self.loading removeFromSuperview];
}

@synthesize loading;

@end