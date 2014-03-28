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

#import "ORGroupTest.h"
#import "ORGroup_Private.h"
#import "ORScreen_Private.h"
#import "ORObjectIdentifier.h"

@interface ORGroupTest ()

@property (nonatomic, strong) ORGroup *testGroup;

@end

@implementation ORGroupTest

- (void)setUp
{
    self.testGroup = [[ORGroup alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] name:@"Group"];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]
                                                                    name:@"Portrait screen"
                                                             orientation:ORScreenOrientationPortrait]];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3]
                                                                    name:@"Landscape screen"
                                                             orientation:ORScreenOrientationLandscape]];
}

- (void)testPortraitScreensCollection
{
    STAssertEquals((NSUInteger)1, [[self.testGroup portraitScreens] count], @"There should be 1 screen in portrait orientation in the group");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:2],
                         [[[self.testGroup portraitScreens] lastObject] identifier],
                         @"Portrait screen in group has id 2");
}

- (void)testLandscapeScreensCollection
{
    STAssertEquals((NSUInteger)1, [[self.testGroup landscapeScreens] count], @"There should be 1 screen in landscape orientation in the group");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:3],
                         [[[self.testGroup landscapeScreens] lastObject] identifier],
                         @"Landscape screen in group has id 3");
}

- (void)testFindScreenByIdentifierForExistingIdentifier
{
    ORScreen *screen = [self.testGroup findScreenByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]];
    STAssertNotNil(screen, @"There should be one screen with id 2 in the group");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:2], screen.identifier, @"Found screen should have id 2");
}

- (void)testFindScreenByIdentifierForNonExistingIdentifier
{
    STAssertNil([self.testGroup findScreenByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:4]], @"There should be no screen with id 4 in the group");
}

@end