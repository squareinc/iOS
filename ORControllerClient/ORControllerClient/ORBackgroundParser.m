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

#import "ORBackgroundParser.h"
#import "ORBackground.h"
#import "ORImageParser.h"
#import "XMLEntity.h"
#import "DefinitionElementParserRegister.h"

@interface ORBackgroundParser ()

@property (nonatomic, strong, readwrite) ORBackground *background;

@end

@implementation ORBackgroundParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:IMAGE];
        self.background = [[ORBackground alloc] init];
        self.background.repeat = ORBackgroundRepeatNoRepeat;
        
        NSString *relativeStr = [attributeDict objectForKey:@"relative"];
        if (relativeStr) {
            self.background.positionUnit = ORWidgetUnitPercentage;
            if ([BG_IMAGE_RELATIVE_POSITION_LEFT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(0.0, 50.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_RIGHT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(100.0, 50.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_TOP isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(50.0, 0.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_BOTTOM isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(50.0, 100.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_TOP_LEFT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(0.0, 0.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_BOTTOM_LEFT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(0.0, 100.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_TOP_RIGHT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(100.0, 0.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_BOTTOM_RIGHT isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(100.0, 100.0);
            } else if ([BG_IMAGE_RELATIVE_POSITION_CENTER isEqualToString:relativeStr]) {
                self.background.position = CGPointMake(50.0, 50.0);
            } else {
                // Not supported relative position, fallback to center
                self.background.position = CGPointMake(50.0, 50.0);
            }
        } else {
            NSString *absoluteStr = [attributeDict objectForKey:@"absolute"];
			NSRange rangeOfComma = [absoluteStr rangeOfString:@","];
			int indexOfComma = rangeOfComma.location;
            self.background.position = CGPointMake([[absoluteStr substringToIndex:indexOfComma] floatValue], [[absoluteStr substringFromIndex:indexOfComma+1] floatValue]);
            self.background.positionUnit = ORWidgetUnitLength;
        }
        NSString *fillScreen =[[attributeDict objectForKey:@"fillScreen"] lowercaseString];
        if (!fillScreen || [@"true" isEqualToString:fillScreen]) {
            self.background.size = CGSizeMake(100.0, 100.0);
            self.background.sizeUnit = ORWidgetUnitPercentage;
        }
        self.background.definition = aRegister.definition;
    }
    return self;
}

- (void)endImageElement:(ORImageParser *)parser
{
    self.background.image = parser.image;
}

@synthesize background;

@end