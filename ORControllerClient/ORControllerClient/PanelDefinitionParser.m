/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "PanelDefinitionParser.h"
#import "Definition.h"
#import "DefinitionElementParserRegister.h"
#import "DefinitionParser.h"
#import "ORScreenParser.h"
#import "ORGroupParser.h"
#import "ORTabBarParser.h"
#import "AbsoluteLayoutContainerParser.h"
#import "GridLayoutContainerParser.h"
#import "ORGestureParser.h"
#import "ORBackgroundParser.h"
#import "GridCellParser.h"
#import "ORLabelParser.h"
#import "ORImageParser.h"
#import "ORWebViewParser.h"
#import "ORSwitchParser.h"
#import "ORSliderParser.h"
#import "ORColorPickerParser.h"
#import "ORNavigationParser.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "ORTabBarItemParser.h"
#import "SensorParser.h"
#import "CommandParser.h"
#import "LocalParser.h"
#import "PropertyParser.h"
#import "ControllerButtonParser.h"
#import "ControllerSwitchParser.h"
#import "ControllerSliderParser.h"
#import "XMLEntity.h"

#import "ORButtonParser_2_0_0.h"

// TODO: the parsing "factory" should be injected based on the configuration retrieved from the controller
// TODO: note: the openremote tag presence is not checked, is this an issue ?

@interface PanelDefinitionParser()

@property (nonatomic, retain) DefinitionElementParserRegister *depRegistry;

@end

@implementation PanelDefinitionParser

- (id)init
{
    self = [super init];
    if (self) {
        self.depRegistry = [[DefinitionElementParserRegister alloc] init];
        [self.depRegistry registerParserClass:[DefinitionParser class] endSelector:NULL forTag:@"openremote"];
        [self.depRegistry registerParserClass:[ORScreenParser class] endSelector:@selector(endScreenElement:) forTag:@"screen"];
        [self.depRegistry registerParserClass:[ORGroupParser class] endSelector:@selector(endGroupElement:) forTag:@"group"];
        [self.depRegistry registerParserClass:[ORTabBarParser class] endSelector:@selector(endTabBarElement:) forTag:@"tabbar"];
        [self.depRegistry registerParserClass:[AbsoluteLayoutContainerParser class] endSelector:@selector(endLayoutElement:) forTag:ABSOLUTE];
        [self.depRegistry registerParserClass:[GridLayoutContainerParser class] endSelector:@selector(endLayoutElement:) forTag:GRID];
        [self.depRegistry registerParserClass:[ORGestureParser class] endSelector:@selector(endGestureElement:) forTag:GESTURE];
        [self.depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(endNavigateElement:) forTag:NAVIGATE];
        [self.depRegistry registerParserClass:[ORBackgroundParser class] endSelector:@selector(endBackgroundElement:) forTag:BACKGROUND];
        [self.depRegistry registerParserClass:[GridCellParser class] endSelector:@selector(endCellElement:) forTag:@"cell"];
        [self.depRegistry registerParserClass:[ORLabelParser class] endSelector:@selector(endLabelElement:) forTag:LABEL];
        [self.depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:IMAGE];
        [self.depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
        [self.depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
        [self.depRegistry registerParserClass:[ORWebViewParser class] endSelector:@selector(endWebElement:) forTag:WEB];

        [self.depRegistry registerParserClass:[ORButtonParser_2_0_0 class] endSelector:@selector(endButtonElement:) forTag:BUTTON];

        [self.depRegistry registerParserClass:[ORSwitchParser class] endSelector:@selector(endSwitchElement:) forTag:SWITCH];
        [self.depRegistry registerParserClass:[ORSliderParser class] endSelector:@selector(endSliderElement:) forTag:SLIDER];
        [self.depRegistry registerParserClass:[ORColorPickerParser class] endSelector:@selector(endColorPickerElement:) forTag:COLORPICKER];
        [self.depRegistry registerParserClass:[ORTabBarItemParser class] endSelector:@selector(endTabBarItemElement:) forTag:ITEM];
        
        [self.depRegistry registerParserClass:[LocalParser class] endSelector:@selector(endLocalElement:) forTag:@"local"];
        [self.depRegistry registerParserClass:[ControllerButtonParser class] endSelector:@selector(endButtonElement:) forTag:@"ctrl:button"];
        [self.depRegistry registerParserClass:[ControllerSwitchParser class] endSelector:@selector(endSwitchElement:) forTag:@"ctrl:switch"];
        [self.depRegistry registerParserClass:[ControllerSliderParser class] endSelector:@selector(endSliderElement:) forTag:@"ctrl:slider"];
        [self.depRegistry registerParserClass:[CommandParser class] endSelector:@selector(endCommandElement:) forTag:@"ctrl:command"];
        [self.depRegistry registerParserClass:[PropertyParser class] endSelector:@selector(endPropertyElement:) forTag:@"ctrl:property"];
        [self.depRegistry registerParserClass:[SensorParser class] endSelector:@selector(endSensorElement:) forTag:@"ctrl:sensor"];
    }
    return self;
}

- (Definition *)parseDefinitionFromXML:(NSData *)definitionXMLData
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:definitionXMLData];
    DefinitionParser *parser = [[[self.depRegistry parserClassForTag:@"openremote"] alloc] initWithRegister:self.depRegistry attributes:nil];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    [self.depRegistry performDeferredBindings];
    return parser.definition;
}

@synthesize depRegistry;

@end
