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

#import "ORDeviceListParserTest.h"
#import "ORDevicesParser.h"
#import "ORDevice.h"
#import "ORDevice_Private.h"
#import "ORObjectIdentifier.h"


@implementation ORDeviceListParserTest

- (void)testParseDeviceList
{
    NSString *xml = @"<devices><device id=\"123\" name=\"Device1\"/><device id=\"456\" name=\"Device2\"/></devices>";
    ORDevicesParser *parser = [[ORDevicesParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *devices = [parser parseDevices];
    XCTAssertEqual(devices.count, 2, @"Device count (%d) is not correct. It should be 2", devices.count);
    [self checkDevice:devices[0] identifier:123 name:@"Device1"];
    [self checkDevice:devices[1] identifier:456 name:@"Device2"];
}

- (void)checkDevice:(ORDevice *)device identifier:(NSUInteger)identifier name:(NSString *)name
{
    XCTAssertEqualObjects(device.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:identifier], @"Device identifier is not correct");
    XCTAssertEqualObjects(device.name, name, @"Device name (%@) is not correct. It should be %@", device.name, name);
}
@end
