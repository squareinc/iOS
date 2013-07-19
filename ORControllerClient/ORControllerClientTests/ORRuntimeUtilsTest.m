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

#import "ORRuntimeUtilsTest.h"
#import "ORRuntimeUtils.h"

@protocol ORRuntimeUtils_OneInstanceMethodNoParameterTestProtocol <NSObject>

- (void)anInstanceMethodWithNoParameter;

@end

@protocol ORRuntimeUtils_OneInstanceMethodOneParameterTestProtocol <NSObject>

- (void)anInstanceMethodWithOneParameter:(NSString *)aParameter;

@end

@protocol ORRuntimeUtils_OneClassMethodNoParameterTestProtocol <NSObject>

+ (void)aClassMethodWithNoParameter;

@end

@protocol ORRuntimeUtils_OneClassMethodOneParameterTestProtocol <NSObject>

+ (void)aClassMethodWithOneParameter:(NSString *)aParameter;

@end

@protocol ORRuntimeUtils_OneInstanceMethodAndSomeClassMethodsTestProtocol <NSObject>

- (BOOL)anInstanceMethod;
+ (void)aClassMethodWithNoParam;
+ (void)aClassMethodWithParam:(NSString *)aParameter;
+ (NSString *)aClassMethodWithParamAndReturnValue:(NSString *)aParameter;

@end

@protocol ORRuntimeUtils_OneOptionalInstanceMethodTestProtocol <NSObject>

@optional

- (void)anOptionalInstanceMethod;

@end

@protocol ORRuntimeUtils_AChildTestProtocol <ORRuntimeUtils_OneClassMethodNoParameterTestProtocol>

- (void)aMethodFromChildProtocol;

@end

@implementation ORRuntimeUtilsTest

- (void)testOneInstanceMethodNoParameterFromProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneInstanceMethodNoParameterTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)1, @"Protocol has one method defined");
    STAssertEquals((SEL)[[selectors lastObject] pointerValue], @selector(anInstanceMethodWithNoParameter), @"Returned selector should be the one from the method in the given protocol");
}

- (void)testOneInstanceMethodOneParameterFromProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneInstanceMethodOneParameterTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)1, @"Protocol has one method defined");
    STAssertEquals((SEL)[[selectors lastObject] pointerValue], @selector(anInstanceMethodWithOneParameter:), @"Returned selector should be the one from the method in the given protocol");
}

- (void)testOneClassMethodNoParameterFromProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneClassMethodNoParameterTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)0, @"Protocol has no instance method defined");
}

- (void)testOneClassMethodOneParameterFromProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneClassMethodOneParameterTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)0, @"Protocol has no instance method defined");
}

- (void)testOneInstanceMethodFromProtocolWithMultipleClassMethods
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneInstanceMethodAndSomeClassMethodsTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)1, @"Protocol has one method defined");
    STAssertEquals((SEL)[[selectors lastObject] pointerValue], @selector(anInstanceMethod), @"Returned selector should be the one from the method in the given protocol");
}

- (void)testOneOptionalInstanceMethodFromProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_OneOptionalInstanceMethodTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)1, @"Protocol has one method defined");
    STAssertEquals((SEL)[[selectors lastObject] pointerValue], @selector(anOptionalInstanceMethod), @"Returned selector should be the one from the method in the given protocol");
}

- (void)testOneInstanceMethodFromChildProtocol
{
    NSArray *selectors = [ORRuntimeUtils instanceMethodsSelectorsFromProtocol:@protocol(ORRuntimeUtils_AChildTestProtocol)];
    STAssertNotNil(selectors, @"Should be able to retrieve selectors from protocol");
    STAssertEquals([selectors count], (NSUInteger)1, @"Protocol has one method defined");
    STAssertEquals((SEL)[[selectors lastObject] pointerValue], @selector(aMethodFromChildProtocol), @"Returned selector should be the one from the method in the child protocol only");
}

@end
