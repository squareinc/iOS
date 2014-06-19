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

#import "ORControllerInfoTest.h"
#import "ORControllerInfo.h"

@implementation ORControllerInfoTest

- (void)testCreateWithValidIdentifier
{
    ORControllerInfo *info = [[ORControllerInfo alloc] initWithIdentifier:@"someid"];
    STAssertNotNil(info, @"Creating a controller info with an identifier should be possible");
    STAssertEqualObjects(@"someid", info.identifier, @"Controller info identifier should be the given identifier");
}

- (void)testCreateWithNilIdentifier
{
    STAssertNil([[ORControllerInfo alloc] initWithIdentifier:nil], @"Creating a controller info with no identifier should not be possible");
}

@end