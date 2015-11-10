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

#import "ORControllerTest.h"
#import "ORControllerAddress.h"
#import "ORController.h"

@implementation ORControllerTest

- (void)testCreateWithValidAddress;
{
    ORControllerAddress *address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:@"http://localhost:8688/controller"]];
    ORController *orb = [[ORController alloc] initWithControllerAddress:address];
    XCTAssertNotNil(orb, @"Creating an ORController with a valid ORControllerAddress should be possible");
    XCTAssertFalse([orb isConnected], @"Newly created ORController should not be connected");
}

- (void)testCreateWithNilAddress
{
    ORController *orb = [[ORController alloc] initWithControllerAddress:nil];
    XCTAssertNil(orb, @"Creating an ORController with no address should not be possible");
}

@end
