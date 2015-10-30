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

#import "ORScreenTest.h"
#import "ORScreen_Private.h"
#import "ORObjectIdentifier.h"
#import "ORGesture_Private.h"
#import "ORAbsoluteLayoutContainer_Private.h"
#import "ORGridLayoutContainer_Private.h"

@interface ORScreenTest ()

@property (nonatomic, strong) ORScreen *testScreen;
@property (nonatomic, strong) ORLayoutContainer *layout1;
@property (nonatomic, strong) ORLayoutContainer *layout2;

@end

@implementation ORScreenTest

- (void)setUp
{
    self.testScreen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1]
                                                            name:@"Screen"
                                                     orientation:ORScreenOrientationPortrait];

    [self.testScreen addGesture:[[ORGesture alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:11]
                                                          gestureType:ORGestureTypeSwipeLeftToRight
                                                           hasCommand:NO]];
    self.layout1 = [[ORAbsoluteLayoutContainer alloc] initWithLeft:1 top:2 width:3 height:4];
    [self.testScreen addLayout:self.layout1];
    self.layout2 = [[ORGridLayoutContainer alloc] initWithLeft:11 top:12 width:13 height:14 rows:1 cols:2];
    [self.testScreen addLayout:self.layout2];
}

- (void)testScreenForOrientationLookup
{
    ORScreen *portraitScreen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]
                                                                         name:@"Portrait screen"
                                                                  orientation:ORScreenOrientationPortrait];
    XCTAssertEqual([portraitScreen screenForOrientation:ORScreenOrientationPortrait], portraitScreen,
                   @"Screen for portrait orientation should be target itself");
    XCTAssertEqual([portraitScreen screenForOrientation:ORScreenOrientationLandscape], portraitScreen,
                   @"Screen for landscape orientation should be target itself as there is no specific screen for landscape");
    
    ORScreen *landscapeScreen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3]
                                                                          name:@"Landscape screen"
                                                                   orientation:ORScreenOrientationLandscape];
    XCTAssertEqual([landscapeScreen screenForOrientation:ORScreenOrientationLandscape], landscapeScreen,
                   @"Screen for landscape orientation should be target itself");
    XCTAssertEqual([landscapeScreen screenForOrientation:ORScreenOrientationPortrait], landscapeScreen,
                   @"Screen for portrait orientation should be target itself as there is no specific screen for portrait");
    
    portraitScreen.rotatedScreen = landscapeScreen;
    landscapeScreen.rotatedScreen = portraitScreen;
    
    XCTAssertEqual([portraitScreen screenForOrientation:ORScreenOrientationPortrait], portraitScreen,
                   @"Screen for portrait orientation should be target itself");
    XCTAssertEqual([portraitScreen screenForOrientation:ORScreenOrientationLandscape], landscapeScreen,
                   @"Screen for landscape orientation should be landscape screen");

    XCTAssertEqual([landscapeScreen screenForOrientation:ORScreenOrientationLandscape], landscapeScreen,
                   @"Screen for landscape orientation should be target itself");
    XCTAssertEqual([landscapeScreen screenForOrientation:ORScreenOrientationPortrait], portraitScreen,
                   @"Screen for portrait orientation should be portrait screen");
}

- (void)testAddingGestureWithExistingIdDoesNotAddOrUpdateGesture
{
    ORGesture *newGesture = [[ORGesture alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:11]
                                                      gestureType:ORGestureTypeSwipeTopToBottom
                                                       hasCommand:YES];

    [self.testScreen addGesture:newGesture];
    
    XCTAssertEqual((NSUInteger)1, [self.testScreen.gestures count], @"There is still 1 gesture in the screen");

    ORGesture *gesture = [self.testScreen.gestures lastObject];
    XCTAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Tested gesture id is not correct");
    XCTAssertEqual(gesture.gestureType, ORGestureTypeSwipeLeftToRight, @"Gesture type has not been updated");
    XCTAssertFalse(gesture.hasCommand, @"Gesture hasCommand property has not been updated");
}


- (void)testAddingGestureForExistingTypeDoesNotAddOrUpdateGesture
{
    ORGesture *newGesture = [[ORGesture alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:13]
                                                      gestureType:ORGestureTypeSwipeLeftToRight
                                                       hasCommand:YES];
    
    [self.testScreen addGesture:newGesture];
    
    XCTAssertEqual((NSUInteger)1, [self.testScreen.gestures count], @"There is still 1 gesture in the screen");
    
    ORGesture *gesture = [self.testScreen.gestures lastObject];
    XCTAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Gesture id has not been updated");
    XCTAssertEqual(gesture.gestureType, ORGestureTypeSwipeLeftToRight, @"Gesture type has not been updated");
    XCTAssertFalse(gesture.hasCommand, @"Gesture hasCommand property has not been updated");
}

- (void)testGestureForType
{
    ORGesture *gesture = [self.testScreen gestureForType:ORGestureTypeSwipeLeftToRight];
    XCTAssertEqualObjects(gesture.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:11], @"Returned gesture should have id 11");
    XCTAssertEqual(gesture.gestureType, ORGestureTypeSwipeLeftToRight, @"Returned gesture should have swipe left to right type");
    XCTAssertFalse(gesture.hasCommand, @"Returned gesture should have hasCommand property set to false");
    
    XCTAssertNil([self.testScreen gestureForType:ORGestureTypeSwipeTopToBottom], @"Screen should not have any top to bottom gesture registed");
}

- (void)testAddGesture
{
    XCTAssertEqual((NSUInteger)1, [self.testScreen.gestures count], @"There should be 1 gesture in test screen");
    XCTAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:11], [self.testScreen.gestures[0] identifier],
                         @"First gesture in screen should have id 11");

    [self.testScreen addGesture:[[ORGesture alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:13]
                                                          gestureType:ORGestureTypeSwipeBottomToTop
                                                           hasCommand:YES]];
    
    XCTAssertEqual((NSUInteger)2, [self.testScreen.gestures count], @"There should be 2 gestures in test screen");
}

- (void)testLayoutsCollectionOrderCorrect
{
    XCTAssertEqual((NSUInteger)2, [self.testScreen.layouts count], @"There should be 2 layouts in test screen");
    XCTAssertEqual(self.testScreen.layouts[0], self.layout1, @"First layout is not in first position in collection");
    XCTAssertEqual(self.testScreen.layouts[1], self.layout2, @"Second layout is not in second position in collection");

    ORLayoutContainer *layout = [[ORAbsoluteLayoutContainer alloc] initWithLeft:21 top:22 width:23 height:24];
    [self.testScreen addLayout:layout];
    XCTAssertEqual((NSUInteger)3, [self.testScreen.layouts count], @"There should be 3 layouts in test screen");
    XCTAssertEqual(self.testScreen.layouts[0], self.layout1, @"First layout is not in first position in collection");
    XCTAssertEqual(self.testScreen.layouts[1], self.layout2, @"Second layout is not in second position in collection");
    XCTAssertEqual(self.testScreen.layouts[2], layout, @"Newly added layout is not in third position in collection");
}

@end