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

#import <SenTestingKit/SenTestingKit.h>
#import "ORWidget.h"
#import "ORObjectIdentifier.h"

@interface ORWidgetTest : SenTestCase

@end

@implementation ORWidgetTest

/**
 * Validates that initializer does return object with id set as expected.
 */
- (void)testInitDoesSetTextCorrectly
{
    ORWidget *widget = [[ORWidget alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1]];
    STAssertNotNil(widget, @"Widget should have been instantied correctly");
    STAssertEqualObjects([[ORObjectIdentifier alloc] initWithIntegerId:1], widget.identifier, @"Identifier property of widget should be one set by initializer");
}

@end
