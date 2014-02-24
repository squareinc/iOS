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

#import "ScreenReferenceStackTest.h"
#import "ScreenReferenceStack.h"
#import "ScreenReference.h"

@implementation ScreenReferenceStackTest

- (void)testPopOnEmptyStackReturnsNil
{
    ScreenReferenceStack *stack = [[ScreenReferenceStack alloc] initWithCapacity:10];
    STAssertNil([stack pop], @"Poping an empty stack should not return anything");
}

- (void)testPushAndPop
{
    ScreenReferenceStack *stack = [[ScreenReferenceStack alloc] initWithCapacity:10];
    ScreenReference *ref = [[ScreenReference alloc] initWithGroupId:1 screenId:2];
    [stack push:ref];
    ScreenReference *poppedRef = [stack pop];
    STAssertNotNil(poppedRef, @"Should be able to pop an object from a stack where one was pushed before");
    STAssertEquals(ref, poppedRef, @"Object poped from stack should be one pushed before");
    STAssertNil([stack pop], @"It should not be possible to pop a second object from the stack");
}

- (void)testStackBehavesAsFIFO
{
    ScreenReferenceStack *stack = [[ScreenReferenceStack alloc] initWithCapacity:10];
    ScreenReference *ref1 = [[ScreenReference alloc] initWithGroupId:1 screenId:2];
    [stack push:ref1];
    ScreenReference *ref2 = [[ScreenReference alloc] initWithGroupId:1 screenId:3];
    [stack push:ref2];
    STAssertEquals(ref2, [stack pop], @"First poped object should be the last one pushed");
    STAssertEquals(ref1, [stack pop], @"Second poped object should be the first one pushed");
}

- (void)testStackDiscardsItemWhenCapacityReached
{
    ScreenReferenceStack *stack = [[ScreenReferenceStack alloc] initWithCapacity:2];
    [stack push:[[ScreenReference alloc] initWithGroupId:1 screenId:1]];
    ScreenReference *ref1 = [[ScreenReference alloc] initWithGroupId:1 screenId:2];
    [stack push:ref1];
    ScreenReference *ref2 = [[ScreenReference alloc] initWithGroupId:1 screenId:3];
    [stack push:ref2];
    STAssertEquals(ref2, [stack pop], @"First poped object should be the last one pushed");
    STAssertEquals(ref1, [stack pop], @"Second poped object should be the one pushed before");
    STAssertNil([stack pop], @"First pushed object should have been discarded from stack");
}

@end