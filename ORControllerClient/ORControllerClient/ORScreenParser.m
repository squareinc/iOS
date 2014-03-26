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

#import "ORScreenParser.h"
#import "ORScreen_Private.h"
#import "ORModelObject_Private.h"
#import "ORAbsoluteLayoutContainerParser.h"
#import "ORGridLayoutContainerParser.h"
#import "ORAbsoluteLayoutContainer.h"
#import "ORGridLayoutContainer.h"
#import "ORBackgroundParser.h"
#import "ORGestureParser.h"
#import "DefinitionElementParserRegister.h"
#import "ORScreenScreenDeferredBinding.h"
#import "XMLEntity.h"
#import "ORObjectIdentifier.h"

@interface ORScreenParser ()

@property (nonatomic, strong, readwrite) ORScreen *screen;

@end

@implementation ORScreenParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:ABSOLUTE];
        [self addKnownTag:GRID];
        [self addKnownTag:GESTURE];
        [self addKnownTag:BACKGROUND];
        self.screen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:ID]]
                                                            name:[attributeDict objectForKey:NAME]
                                                     orientation:[@"TRUE" isEqualToString:[[attributeDict objectForKey:LANDSCAPE] uppercaseString]]?ORScreenOrientationLandscape:ORScreenOrientationPortrait];
        self.screen.definition = aRegister.definition;
        if ([attributeDict objectForKey:INVERSE_SCREEN_ID]) {
            ORScreenScreenDeferredBinding *standby = [[ORScreenScreenDeferredBinding alloc] initWithBoundComponentIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:INVERSE_SCREEN_ID]] enclosingObject:self.screen];
            [self.depRegister addDeferredBinding:standby];
        }
    }
    
    // TODO: check how to report error ?
    
    return self;
}

- (void)endAbsoluteLayoutElement:(ORAbsoluteLayoutContainerParser *)parser
{
    [self.screen addLayout:parser.layoutContainer];
}

- (void)endGridLayoutElement:(ORGridLayoutContainerParser *)parser
{
    [self.screen addLayout:parser.layoutContainer];
}

- (void)endGestureElement:(ORGestureParser *)parser
{
    [self.screen addGesture:parser.gesture];
}

- (void)endBackgroundElement:(ORBackgroundParser *)parser
{
    self.screen.background = parser.background;
}

- (NSString *)handledTag
{
    return @"screen";
}

@synthesize screen;

@end