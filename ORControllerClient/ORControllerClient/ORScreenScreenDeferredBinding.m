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
#import "ORScreenScreenDeferredBinding.h"
#import "ORScreen_Private.h"
#import "Definition.h"

@implementation ORScreenScreenDeferredBinding

- (id)initWithBoundComponentId:(ORObjectIdentifier *)anIdentifier enclosingObject:(ORModelObject *)anEnclosingObject
{
    if (![anEnclosingObject isKindOfClass:[ORScreen class]]) {
        return nil;
    }
    self = [super initWithBoundComponentId:anIdentifier enclosingObject:anEnclosingObject];
    return self;
}

- (void)bind
{
    ((ORScreen *)self.enclosingObject).rotatedScreen = [self.enclosingObject.definition findScreenByIdentifier:self.boundComponentId];
}

@end
