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

#import "ORDeviceParserTest.h"
#import "ORDevice.h"
#import "ORDeviceParser.h"
#import "ORDevice_Private.h"
#import "ORObjectIdentifier.h"
#import "ORDeviceCommand.h"
#import "ORDeviceCommand_Private.h"
#import "ORDeviceSensor.h"


@implementation ORDeviceParserTest

- (void)testParseDevice
{
    NSData *xmlData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DevicesTest" ofType:@"xml"]];
    ORDeviceParser *parser = [[ORDeviceParser alloc] initWithData:xmlData];
    ORDevice *device = [parser parseDevice];
    XCTAssertNotNil(device);
    NSString *correctName = @"DeviceName";
    XCTAssertEqualObjects(device.name, correctName, @"Device name (%@) is not correct. It should be %@", device.name, correctName);
    int correctId = 12345;
    XCTAssertEqualObjects(device.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:correctId], @"Device identifier (%@) is not correct. It should be %d", device.identifier, correctId);

    int commandCorrectCount = 1;
    XCTAssertEqual(device.commands.count, commandCorrectCount, @"Device commands count (%d) is not correct. It should be %d", device.commands.count, commandCorrectCount);
    ORDeviceCommand *command = [device.commands firstObject];
    XCTAssertEqualObjects(command.name, @"CommandName", @"Command name (%@) is not correct. It should be %@", command.name, @"CommandName");
    XCTAssertEqualObjects(command.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:1234], @"Command identifier (%@) is not correct. It should be %d", command.identifier, 1234);
    XCTAssertEqualObjects(command.protocol, @"ProtocolName", @"Command protocol (%@) is not correct. It should be %@", command.protocol, @"ProtocolName");
    XCTAssertEqual(command.device, device, @"Owner device is not correct");

    int commandTagsCorrectCount = 2;
    XCTAssertEqual(command.tags.count, commandTagsCorrectCount, @"Command tags count (%d) is not correct. It should be %d", command.tags.count, commandTagsCorrectCount);
    XCTAssertTrue([command.tags containsObject:@"tag 1"], @"Tag with value \"tag 1\" not found");
    XCTAssertTrue([command.tags containsObject:@"<tag & 2>"], @"Tag with value \"<tag & 2>\" not found");

    int sensorsCorrectCount = 6;
    XCTAssertEqual(device.sensors.count, sensorsCorrectCount, @"Device commands count (%d) is not correct. It should be %d", device.sensors.count, sensorsCorrectCount);
    [self checkSensor:device.sensors[0] correctName:@"SensorName1" correctType:SensorTypeSwitch correctIdentifier:123 correctCommand:command correctDevice:device];
    [self checkSensor:device.sensors[1] correctName:@"SensorName2" correctType:SensorTypeLevel correctIdentifier:456 correctCommand:command correctDevice:device];
    [self checkSensor:device.sensors[2] correctName:@"SensorName3" correctType:SensorTypeRange correctIdentifier:789 correctCommand:command correctDevice:device];
    [self checkSensor:device.sensors[3] correctName:@"SensorName4" correctType:SensorTypeColor correctIdentifier:123 correctCommand:command correctDevice:device];
    [self checkSensor:device.sensors[4] correctName:@"SensorName5" correctType:SensorTypeCustom correctIdentifier:234 correctCommand:command correctDevice:device];
    [self checkSensor:device.sensors[5] correctName:@"SensorName6" correctType:SensorTypeUnknown correctIdentifier:111 correctCommand:command correctDevice:device];
}

- (void)checkSensor:(ORDeviceSensor *)sensor correctName:(NSString *)sensorName correctType:(SensorType)sensorType correctIdentifier:(int)sensorIdentifier correctCommand:(ORDeviceCommand *)command correctDevice:(ORDevice *)device
{
    XCTAssertEqualObjects(sensor.name, sensorName, @"Sensor name (%@) is not correct. It should be %@", sensor.name, sensorName);
    XCTAssertEqualObjects(sensor.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:sensorIdentifier], @"Command identifier (%@) is not correct. It should be %d", sensor.identifier, sensorIdentifier);
    XCTAssertEqual(sensor.type, sensorType, @"Sensor type (%d) is not correct. It should be %d", sensor.type, sensorType);
    XCTAssertEqualObjects(sensor.command, command, @"Sensor command is not correct.");
    XCTAssertEqual(sensor.device, device, @"Owner device is not correct");
}

@end
