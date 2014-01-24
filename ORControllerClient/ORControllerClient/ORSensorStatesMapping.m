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

#import "ORSensorStatesMapping.h"
#import "ORSensorState.h"

@interface ORSensorStatesMapping ()

@property (nonatomic, strong) NSMutableDictionary *states;

@end

@implementation ORSensorStatesMapping

- (id)init
{
    self = [super init];
    if (self) {
        self.states = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addSensorState:(ORSensorState *)state
{
    [self.states setObject:state forKey:state.name];
}

- (NSString *)stateValueForName:(NSString *)stateName
{
    ORSensorState *state = [self.states objectForKey:stateName];
    return (state)?state.value:nil;
}

// TODO: check why case insensitive match was used in original code, is that defined somewhere ?

@end
