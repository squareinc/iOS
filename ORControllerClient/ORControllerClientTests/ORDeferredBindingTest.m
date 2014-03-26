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

#import "ORDeferredBindingTest.h"
#import "ORDeferredBinding.h"
#import "ORObjectIdentifier.h"
#import "ORWidget.h"

@implementation ORDeferredBindingTest

- (void)testCreateValidBinding
{
    ORObjectIdentifier *identifier = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORWidget *widget = [[ORWidget alloc] initWithId:2];
    ORDeferredBinding *binding = [[ORDeferredBinding alloc] initWithBoundComponentIdentifier:identifier enclosingObject:widget];
    STAssertNotNil(binding, @"Creating a deferred binding should be possible");
    STAssertEqualObjects(identifier, binding.boundComponentId, @"Bound component identifier should be one used to create binding");
    STAssertEqualObjects(widget, binding.enclosingObject, @"Enclosing object should be one used to create binding");
}

- (void)testFailCreateBindingWithNilParameters
{
    ORObjectIdentifier *identifier = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORWidget *widget = [[ORWidget alloc] initWithId:2];
    ORDeferredBinding *binding = [[ORDeferredBinding alloc] initWithBoundComponentIdentifier:nil enclosingObject:nil];
    STAssertNil(binding, @"It should not be possible to create a binding with nil parameters");
    
    binding = [[ORDeferredBinding alloc] initWithBoundComponentIdentifier:identifier enclosingObject:nil];
    STAssertNil(binding, @"It should not be possible to create a binding with nil identifier");

    binding = [[ORDeferredBinding alloc] initWithBoundComponentIdentifier:nil enclosingObject:widget];
    STAssertNil(binding, @"It should not be possible to create a binding with nil enclosing object");
}

- (void)testBindIsAbstract
{
    ORObjectIdentifier *identifier = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORWidget *widget = [[ORWidget alloc] initWithId:2];
    ORDeferredBinding *binding = [[ORDeferredBinding alloc] initWithBoundComponentIdentifier:identifier enclosingObject:widget];
    @try {
        [binding bind];
        STFail(@"bind method is abstract and should not be executed correctly");
    } @catch (NSException *e) {
        if (![NSInvalidArgumentException isEqualToString:e.name]) {
            @throw e;
        }
    }
}

@end
