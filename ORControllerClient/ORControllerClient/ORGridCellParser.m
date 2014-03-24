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
#import "ORGridCellParser.h"
#import "ORGridCell_Private.h"
#import "ORLabelParser.h"
#import "ORImageParser.h"
#import "ORWebViewParser.h"
#import "ORButtonParser.h"
#import "ORButton.h"
#import "ORSwitchParser.h"
#import "ORSwitch.h"
#import "ORSliderParser.h"
#import "ORSlider.h"
#import "ORColorPickerParser.h"
#import "DefinitionElementParserRegister.h"
#import "Definition.h"
#import "XMLEntity.h"

@interface ORGridCellParser()

@property (nonatomic, strong, readwrite) ORGridCell *cell;

@end

@implementation ORGridCellParser

- (instancetype)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:LABEL];
        [self addKnownTag:IMAGE];
        [self addKnownTag:WEB];
        [self addKnownTag:BUTTON];
        [self addKnownTag:SWITCH];
        [self addKnownTag:SLIDER];
        [self addKnownTag:COLORPICKER];
        self.cell = [[ORGridCell alloc] initWithX:[[attributeDict objectForKey:@"x"] integerValue]
                                                  y:[[attributeDict objectForKey:@"y"] integerValue]
                                            rowspan:[[attributeDict objectForKey:@"rowspan"] integerValue]
                                            colspan:[[attributeDict objectForKey:@"colspan"] integerValue]];
    }
    return self;
}

- (void)endLabelElement:(ORLabelParser *)parser
{
    self.cell.widget = parser.label;
    [self.depRegister.definition addLabel:parser.label];
}

- (void)endImageElement:(ORImageParser *)parser
{
    self.cell.widget = parser.image;
    [self.depRegister.definition addImage:parser.image];
}

- (void)endWebElement:(ORWebViewParser *)parser
{
    self.cell.widget = parser.web;
    [self.depRegister.definition addWebView:parser.web];
}

- (void)endButtonElement:(ORButtonParser *)parser
{
    self.cell.widget = parser.button;
    [self.depRegister.definition addButton:parser.button];
}

- (void)endSwitchElement:(ORSwitchParser *)parser
{
    self.cell.widget = parser.sswitch;
    [self.depRegister.definition addSwitch:parser.sswitch];
}

- (void)endSliderElement:(ORSliderParser *)parser
{
    self.cell.widget = parser.slider;
    [self.depRegister.definition addSlider:parser.slider];
}

- (void)endColorPickerElement:(ORColorPickerParser *)parser
{
    self.cell.widget = parser.colorPicker;
    [self.depRegister.definition addColorPicker:parser.colorPicker];
}

@synthesize cell;

@end