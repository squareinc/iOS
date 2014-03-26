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

#import "ORSwitchTest.h"
#import "ORSwitch_Private.h"
#import "ORWidget_Private.h"
#import "ORImage_Private.h"
#import "ORObjectIdentifier.h"

@implementation ORSwitchTest

- (void)testSwitchWithNoMappingStateUpdateFromString
{
    ORSwitch *sswitch = [[ORSwitch alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1]];
    STAssertNotNil(sswitch, @"Switch should have been created successfully");
    STAssertFalse(sswitch.state, @"Default state for the switch is off");
    
    [sswitch setValue:@"on" forKey:@"state"];
    STAssertTrue(sswitch.state, @"Switch state should have been set on");

    [sswitch setValue:@"off" forKey:@"state"];
    STAssertFalse(sswitch.state, @"Switch state should have been set off");

    [sswitch setValue:@"on" forKey:@"state"];
    STAssertTrue(sswitch.state, @"Switch state should have been set on");

    [sswitch setValue:@"something else" forKey:@"state"];
    STAssertFalse(sswitch.state, @"Switch state should have been set off");
}

- (void)testSwitchWithMappingStateUpdateFromString
{
    ORSwitch *sswitch = [[ORSwitch alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1]];
    sswitch.onImage = [[ORImage alloc] initWithIdentifier:nil name:@"OnImage.png"];
    sswitch.offImage = [[ORImage alloc] initWithIdentifier:nil name:@"OffImage.png"];
    STAssertFalse(sswitch.state, @"Default state for the switch is off");
    
    [sswitch setValue:@"OnImage.png" forKey:@"state"];
    STAssertTrue(sswitch.state, @"Switch state should have been set on");

    [sswitch setValue:@"off" forKey:@"state"];
    STAssertFalse(sswitch.state, @"Switch state should have been set off");
    
    [sswitch setValue:@"on" forKey:@"state"];
    STAssertFalse(sswitch.state, @"Switch state should have been set off");
    
    [sswitch setValue:@"something else" forKey:@"state"];
    STAssertFalse(sswitch.state, @"Switch state should have been set off");
}

@end