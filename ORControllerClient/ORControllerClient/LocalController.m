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
#import "LocalController.h"
#import "ControllerComponent.h"
#import "LocalCommand.h"
#import "LocalSensor.h"
#import "ORObjectIdentifier.h"

@interface LocalController()

@property (nonatomic, strong) NSMutableDictionary *components;
@property (nonatomic, strong) NSMutableDictionary *commands;
@property (nonatomic, strong) NSMutableDictionary *sensors;
@property (nonatomic, strong) NSMutableDictionary *commandsPerComponents;

@end

@implementation LocalController

- (id)init
{
    self = [super init];
    if (self) {
        self.components = [NSMutableDictionary dictionary];
		self.commands = [NSMutableDictionary dictionary];
		self.sensors = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addComponent:(ControllerComponent *)component
{
    [components setObject:component forKey:component.identifier];
}

- (void)addCommand:(LocalCommand *)command
{
    [commands setObject:command forKey:command.identifier];
}

- (void)addSensor:(LocalSensor *)sensor
{
    [sensors setObject:sensor forKey:sensor.identifier];
}

- (ControllerComponent *)componentForIdentifier:(ORObjectIdentifier *)anIdentifier
{
    return [components objectForKey:anIdentifier];
}

- (LocalCommand *)commandForIdentifier:(ORObjectIdentifier *)anIdentifier
{
	return [commands objectForKey:anIdentifier];
}

- (LocalSensor *)sensorForIdentifier:(ORObjectIdentifier *)anIdentifier
{
	return [sensors objectForKey:anIdentifier];
}

/**
 * Returns the list of client side commands for a given component id and action.
 * action is dependant on the component type (e.g. for switch it can be on or off).
 * If the cache of component id -> commands is not yet build, do it know.
 *
 * @param anIdentifier The identifier of the component
 * @param action The name of the action
 */
- (NSArray *)commandsForComponentIdentifier:(ORObjectIdentifier *)anIdentifier action:(NSString *)action
{
    if (!commandsPerComponents) {
        [self buildCommandsPerComponentsCache];
    }
    return [[commandsPerComponents objectForKey:anIdentifier] objectForKey:action];
}

- (void)buildCommandsPerComponentsCache
{
    self.commandsPerComponents = [NSMutableDictionary dictionary];
    for (ControllerComponent *component in [self.components allValues]) {
        [self.commandsPerComponents setObject:[component commandsPerAction] forKey:component.identifier];
    }
}

@synthesize components;
@synthesize commands;
@synthesize sensors;
@synthesize commandsPerComponents;

@end