/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

#import "ORDevice_Private.h"

@interface ORDevice ()


@end

@implementation ORDevice



@synthesize name = _name;
@synthesize identifier = _identifier;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.internalCommands = [[NSMutableArray alloc] init];
        self.internalSensors = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSArray *)commands
{
    return [self.internalCommands copy];
}

- (NSArray *)sensors
{
    return [self.internalSensors copy];
}


@end
