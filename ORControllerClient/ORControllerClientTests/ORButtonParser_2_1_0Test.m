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

#import "ORButtonParser_2_1_0Test.h"

#import "ORButtonParser_2_1_0.h"
#import "ORImageParser.h"
#import "ORButton_Private.h"
#import "ORObjectIdentifier.h"
#import "ORLabel.h"
#import "ORImage.h"
#import "DefinitionElementParserRegister.h"
#import "DefinitionParserMock.h"
#import "ORNavigationParser.h"
#import "ORNavigation.h"
#import "XMLEntity.h"

@implementation ORButtonParser_2_1_0Test

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORButtonParser_2_1_0 class] endSelector:@selector(setTopLevelParser:) forTag:BUTTON];
    [depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(endNavigateElement:) forTag:NAVIGATE];
    [depRegistry registerParserClass:[ORImageParser class] endSelector:@selector(endImageElement:) forTag:IMAGE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:BUTTON];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORButton *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORButtonParser_2_1_0 class]], @"Parser used should be an ORButtonParser");
    ORButton *button = ((ORButtonParser_2_1_0 *)topLevelParser).button;
    STAssertNotNil(button, @"A button should be parsed for given XML snippet");
    
    return button;
}

- (void)testParseButtonWithNoImageNoActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasPressCommand=\"false\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertFalse([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should not have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithShortPressActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasPressCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertTrue([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithShortReleaseActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasShortReleaseCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertFalse([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should not have a press command");
    STAssertTrue([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithLongPressActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasLongPressCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertFalse([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should not have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertTrue([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should have a long press command");
    STAssertEquals([[button valueForKey:@"longPressDelay"] intValue], 250, @"Parsed button should have default long press delay");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithLongReleaseActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasLongReleaseCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertFalse([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should not have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertTrue([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithRepeatingShortPressActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"true\" hasPressCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertTrue([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertEquals([[button valueForKey:@"repeatDelay"] intValue], 300, @"Parsed button should have default repeat rate");
    
    STAssertTrue([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithCustomDelayRepeatingShortPressActionNoNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"true\" repeatDelay=\"500\" hasPressCommand=\"true\"/>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertTrue([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertEquals([[button valueForKey:@"repeatDelay"] intValue], 500, @"Parsed button should have a 500 ms repeat rate");
    
    STAssertTrue([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNil(button.navigation, @"Parsed button should have no navigation associated with it");
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageNoActionWithNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"false\" hasPressCommand=\"false\"><navigate to=\"back\"/></button>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertFalse([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertFalse([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should not have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNotNil(button.navigation, @"Parsed button should have a navigation associated with it");
    STAssertEquals(button.navigation.navigationType, ORNavigationTypeBack, @"Parsed button navigation should navigate back");
    
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithNoImageWithRepeatingActionAndNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"true\" hasPressCommand=\"true\"><navigate to=\"back\"/></button>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertTrue([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertEquals([[button valueForKey:@"repeatDelay"] intValue], 300, @"Parsed button should have default repeat rate");
    
    STAssertTrue([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNotNil(button.navigation, @"Parsed button should have a navigation associated with it");
    STAssertEquals(button.navigation.navigationType, ORNavigationTypeBack, @"Parsed button navigation should navigate back");
    
    STAssertNil(button.unpressedImage, @"Parsed button should have no unpressed image associated with it");
    STAssertNil(button.pressedImage, @"Parsed button should have no pressed image associated with it");
}

- (void)testParseButtonWithImagesWithRepeatingActionAndNavigate
{
    ORButton *button = [self parseValidXMLSnippet:@"<button id=\"10\" name=\"Label 1\" repeat=\"true\" hasPressCommand=\"true\"><default><image src=\"default image\"/></default><pressed><image src=\"pressed image\"/></pressed><navigate to=\"back\"/></button>"];
    
    STAssertNotNil(button.identifier, @"Parsed button should have an identifier");
    STAssertEqualObjects(button.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed button should have 10 as identifer");
    
    STAssertNotNil(button.label, @"Parsed button should have a label");
    STAssertEqualObjects(button.label.text, @"Label 1", @"Parsed button label should be 'Label 1'");
    
    STAssertTrue([[button valueForKey:@"repeat"] boolValue], @"Parsed button should not repeat");
    STAssertEquals([[button valueForKey:@"repeatDelay"] intValue], 300, @"Parsed button should have default repeat rate");
    
    STAssertTrue([[button valueForKey:@"hasPressCommand"] boolValue], @"Parsed button should have a press command");
    STAssertFalse([[button valueForKey:@"hasShortReleaseCommand"] boolValue], @"Parsed button should not have a short release command");
    STAssertFalse([[button valueForKey:@"hasLongPressCommand"] boolValue], @"Parsed button should not have a long press command");
    STAssertFalse([[button valueForKey:@"hasLongReleaseCommand"] boolValue], @"Parsed button should not have a long release command");
    
    STAssertNotNil(button.navigation, @"Parsed button should have a navigation associated with it");
    STAssertEquals(button.navigation.navigationType, ORNavigationTypeBack, @"Parsed button navigation should navigate back");
    
    STAssertNotNil(button.unpressedImage, @"Parsed button should have an unpressed image associated with it");
    STAssertTrue([button.unpressedImage isMemberOfClass:[ORImage class]], @"Parsed button unpressed image should be an ORImage");
    STAssertEqualObjects(button.unpressedImage.src, @"default image", @"Parsed button unpressed image src should be 'default image'");
    
    STAssertNotNil(button.pressedImage, @"Parsed button should have a pressed image associated with it");
    STAssertTrue([button.pressedImage isMemberOfClass:[ORImage class]], @"Parsed button pressed image should be an ORImage");
    STAssertEqualObjects(button.pressedImage.src, @"pressed image", @"Parsed button pressed image src should be 'pressed image'");
}

@end