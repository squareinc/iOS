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

#import "ORGestureParser.h"
#import "ORGesture_Private.h"
#import "ORObjectIdentifier.h"
#import "ORNavigationParser.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"

@interface ORGestureParser ()

@property (nonatomic, strong, readwrite) ORGesture *gesture;

@end

@implementation ORGestureParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:NAVIGATE];
        NSString *type = [attributeDict objectForKey:TYPE];
        ORGestureType gestureType = ORGestureTypeSwipeRightToLeft; // Arbitrary default value, shouldn't be used unless data consistency issue
        if ([type isEqualToString:@"swipe-top-to-bottom"]) {
            gestureType = ORGestureTypeSwipeTopToBottom;
        } else if ([type isEqualToString:@"swipe-bottom-to-top"]) {
            gestureType = ORGestureTypeSwipeBottomToTop;
        } else if ([type isEqualToString:@"swipe-left-to-right"]) {
            gestureType = ORGestureTypeSwipeLeftToRight;
        } else if ([type isEqualToString:@"swipe-right-to-left"]) {
            gestureType = ORGestureTypeSwipeRightToLeft;
        }
        BOOL hasCommand = [@"TRUE" isEqualToString:[[attributeDict objectForKey:@"hasControlCommand"] uppercaseString]];
        self.gesture = [[ORGesture alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                                 gestureType:gestureType
                                                  hasCommand:hasCommand];
        self.gesture.definition = aRegister.definition;
    }
    return self;
}

- (void)endNavigateElement:(ORNavigationParser *)parser
{
    self.gesture.navigation = parser.navigation;
}

@synthesize gesture;

@end