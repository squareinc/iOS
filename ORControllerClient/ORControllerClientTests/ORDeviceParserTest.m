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
#import "ORCommand.h"
#import "ORCommand_Private.h"


@implementation ORDeviceParserTest

- (void)testParseDevice
{
    NSString *xml = @"<device id=\"12345\" name=\"DeviceName\"><commands><command id=\"1234\" name=\"CommandName\" protocol=\"ProtocolName\"/></commands><sensors><sensor id=\"123\" type=\"SensorType\" name=\"SensorName\" command_id=\"321\"/></sensors></device>";
    ORDeviceParser *parser = [[ORDeviceParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    ORDevice *device = [parser parseDevice];
    XCTAssertNotNil(device);
    NSString *correctName = @"DeviceName";
    XCTAssertEqual(device.name, correctName, @"Device name (%@) is not correct. It should be %@", device.name, correctName);
    int correctId = 12345;
    XCTAssertEqual(device.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:correctId], @"Device identifier (%d) is not correct. It should be %d", device.identifier, correctId);

    int correctCount = 1;
    XCTAssertEqual(device.commands.count, correctCount, @"Device commands count (%d) is not correct. It should be %d", device.commands.count, correctCount);
    ORCommand *command = device.commands[0];
    XCTAssertEqual(command.name, @"CommandName", @"Command name (%@) is not correct. It should be %@", command.name, @"CommandName");
    XCTAssertEqual(command.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:1234], @"Command identifier (%@) is not correct. It should be %d", command.identifier, 1234);
    XCTAssertEqual(command.protocol, @"CommandProtocol", @"Command protocol (%@) is not correct. It should be %@\"");

    // todo: sensors
//    XCTAssertEqual(device.sensors.count, 1), @"Device sensors count is not correct");
}

@end
