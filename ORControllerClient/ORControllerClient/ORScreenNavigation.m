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

#import "ORScreenNavigation_Private.h"
#import "ORNavigation_Private.h"

@interface ORScreenNavigation ()

@property (nonatomic, strong, readwrite) ORGroup *destinationGroup;
@property (nonatomic, strong, readwrite) ORScreen *destinationScreen;

@end
@implementation ORScreenNavigation

- (id)initWithDestinationGroup:(ORGroup *)group destinationScreen:(ORScreen *)screen
{
    self = [super initWithNavigationType:ORNavigationToGroupOrScreen];
    if (self) {
        self.destinationGroup = group;
        self.destinationScreen = screen;
    }
    return self;
}

@end