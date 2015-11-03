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

#import "ORControllerDeviceModelTest.h"
#import "ORControllerDeviceModel.h"
#import "ORDevice_Private.h"
#import "ORObjectIdentifier.h"
#import "ORControllerDeviceModel_Private.h"

@interface ORControllerDeviceModelTest ()

@property (nonatomic, strong) ORControllerDeviceModel *model;
@property (nonatomic, strong) ORDevice *device1;
@property (nonatomic, strong) ORDevice *device2;

@end

@implementation ORControllerDeviceModelTest

- (void)setUp
{
    self.device1 = [[ORDevice alloc] init];
    self.device1.name = @"Device1";
    self.device1.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:1];

    self.device2 = [[ORDevice alloc] init];
    self.device2.name = @"Device2";
    self.device2.identifier = [[ORObjectIdentifier alloc] initWithIntegerId:2];

    self.model = [[ORControllerDeviceModel alloc] initWithDevices:@[self.device1, self.device2]];
}

- (void)testFindDeviceById
{
    ORDevice *device = [self.model findDeviceById:[[ORObjectIdentifier alloc] initWithIntegerId:1]];
    XCTAssertEqual(device, self.device1);

    device = [self.model findDeviceById:[[ORObjectIdentifier alloc] initWithIntegerId:2]];
    XCTAssertEqual(device, self.device2);

    device = [self.model findDeviceById:[[ORObjectIdentifier alloc] initWithIntegerId:3]];
    XCTAssertNil(device);

}

- (void)testFindDeviceByName
{
    ORDevice *device = [self.model findDeviceByName:@"Device1"];
    XCTAssertEqual(device, self.device1);

    device = [self.model findDeviceByName:@"Device2"];
    XCTAssertEqual(device, self.device2);

    device = [self.model findDeviceByName:@"Device3"];
    XCTAssertNil(device);

}

- (void)testNSCoding
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.model];
    XCTAssertNotNil(data);
    ORControllerDeviceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(model);
    XCTAssertEqualObjects(self.model, model);
}

@end
