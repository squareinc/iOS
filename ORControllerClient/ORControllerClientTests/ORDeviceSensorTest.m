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

#import "ORDeviceSensorTest.h"
#import "ORDeviceSensor_Private.h"
#import "ORObjectIdentifier.h"
#import "ORDeviceCommand_Private.h"


@implementation ORDeviceSensorTest

- (void)testNSCoding
{
    ORDeviceCommand *command = [[ORDeviceCommand alloc] init];
    command.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:123];
    command.name = @"CommandName";
    [command addTag:@"Tag1"];
    [command addTag:@"Tag2"];

    ORDeviceSensor *sensor = [[ORDeviceSensor alloc] init];
    sensor.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    sensor.name = @"SensorName";
    sensor.type = SensorTypeSwitch;
    sensor.command = command;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sensor];
    XCTAssertNotNil(data);
    ORDeviceSensor *newSensor = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(newSensor);
    XCTAssertEqualObjects(newSensor, sensor);

}

@end
