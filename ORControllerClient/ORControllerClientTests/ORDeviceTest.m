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

#import "ORDeviceTest.h"
#import "ORDevice_Private.h"
#import "ORDeviceCommand_Private.h"
#import "ORDeviceSensor_Private.h"
#import "ORObjectIdentifier.h"

@interface ORDeviceTest ()

@property (nonatomic, strong) ORDevice *device;

@property(nonatomic, strong) ORDeviceCommand *command1;
@property(nonatomic, strong) ORDeviceCommand *command2;
@property(nonatomic, strong) ORDeviceCommand *command3;

@property(nonatomic, strong) ORDeviceSensor *sensor1;

@end

@implementation ORDeviceTest

- (void)setUp
{
    [super setUp];
    self.device = [[ORDevice alloc] init];
    self.device.name = @"DeviceName";
    self.device.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:12345];

    self.command1 = [[ORDeviceCommand alloc] init];
    self.command1.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:22];
    self.command1.name = @"Command1";
    self.command1.protocol = @"Protocol";
    [self.command1 addTag:@"Tag1"];
    [self.command1 addTag:@"Tag2"];
    [self.device addCommand:self.command1];

    self.command2 = [[ORDeviceCommand alloc] init];
    self.command2.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:33];
    self.command2.name = @"command2";
    self.command2.protocol = @"Protocol";
    [self.command2 addTag:@"Tag3"];
    [self.command2 addTag:@"Tag2"];
    [self.device addCommand:self.command2];

    self.command3 = [[ORDeviceCommand alloc] init];
    self.command3.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:44];
    self.command3.name = @"command3";
    self.command3.protocol = @"Protocol2";
    [self.command3 addTag:@"Tag4"];
    [self.device addCommand:self.command3];
    
    self.sensor1 = [[ORDeviceSensor alloc] init];
    self.sensor1.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:55];
    self.sensor1.type = SensorTypeSwitch;
    self.sensor1.name = @"Sensor1";
    self.sensor1.command = self.command1;
    [self.device addSensor:self.sensor1];
}

- (void)testFindCommandById
{
    ORDeviceCommand *command = [self.device findCommandById:[[ORObjectIdentifier alloc] initWithIntegerId:22]];
    XCTAssertEqual(command, self.command1);

    command = [self.device findCommandById:[[ORObjectIdentifier alloc] initWithIntegerId:99999]];
    XCTAssertNil(command);
}

- (void)testFindCommandByName
{
    ORDeviceCommand *command = [self.device findCommandByName:@"command2"];
    XCTAssertEqual(command, self.command2);

    command = [self.device findCommandByName:@"NonExistingCommand"];
    XCTAssertNil(command);
}

- (void)testFindCommandsByTags
{
    NSSet *commands = [self.device findCommandsByTags:[NSSet setWithObjects:@"Tag1", nil]];
    XCTAssertEqual(commands.count, 1);
    XCTAssertEqual([commands allObjects][0], self.command1);

    commands = [self.device findCommandsByTags:[NSSet setWithObjects:@"Tag2", nil]];
    XCTAssertEqual(commands.count, 2);
    XCTAssertTrue([commands containsObject:self.command1]);
    XCTAssertTrue([commands containsObject:self.command2]);

    commands = [self.device findCommandsByTags:[NSSet setWithObjects:@"Tag1", @"Tag4", nil]];
    XCTAssertEqual(commands.count, 2);
    XCTAssertTrue([commands containsObject:self.command1]);
    XCTAssertTrue([commands containsObject:self.command3]);

    commands = [self.device findCommandsByTags:[NSSet setWithObjects:@"NonTag", @"OtherNonTag", nil]];
    XCTAssertEqual(commands.count, 0);
}

- (void)testFindSensorById
{
    ORDeviceSensor *sensor = [self.device findSensorById:[[ORObjectIdentifier alloc] initWithIntegerId:55]];
    XCTAssertEqual(sensor, self.sensor1);

    sensor = [self.device findSensorById:[[ORObjectIdentifier alloc] initWithIntegerId:99999]];
    XCTAssertNil(sensor);
}

- (void)testFindSensorByName
{
    ORDeviceSensor *sensor = [self.device findSensorByName:@"Sensor1"];
    XCTAssertEqual(sensor, self.sensor1);

    sensor = [self.device findSensorByName:@"NonExistingSensor"];
    XCTAssertNil(sensor);
}

@end
