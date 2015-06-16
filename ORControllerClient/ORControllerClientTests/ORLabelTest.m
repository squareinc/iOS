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
#import "ORObjectIdentifier.h"
#import "ORLabel_Private.h"

#define SOME_TEXT @"Some text"
#define SOME_OTHER_TEXT @"Some other text"

@interface ORLabelTest : SenTestCase

@property (nonatomic, strong) ORLabel *label;

@end

@implementation ORLabelTest

- (void)setUp
{
    self.label = [[ORLabel alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] text:SOME_TEXT];
}

- (void)tearDown
{
    self.label = nil;
}

/**
 * Validates that initializer does return object with text property set as expected.
 */
- (void)testInitDoesSetTextCorrectly
{
    STAssertNotNil(self.label, @"Label should have been instantied correctly");
    STAssertEqualObjects(self.label.text, SOME_TEXT, @"Text property of label should be one set by initializer");
}

/**
 * Validates that initializer does return object with properties other then text set to default values.
 */
- (void)testInitDoesSetDefaultValuesCorrectly
{
    STAssertNotNil(self.label, @"Label should have been instantied correctly");
    STAssertEqualObjects(self.label.textColor, [UIColor whiteColor], @"Default textColor should be white");
    STAssertEqualObjects(self.label.font, [UIFont fontWithName:@"Arial" size:14.0], @"Default font should be Arial 14pt");
}

/**
 * Validates that KVO is triggered with appropriate value when label text property is changed.
 */
- (void)testKVOWhenSettingLabelText
{
    [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    self.label.text = SOME_OTHER_TEXT;
    [self.label removeObserver:self forKeyPath:@"text"];
}

/**
 * Validates that KVO is triggered with appropriate value when label textColor property is changed.
 */
- (void)testKVOWhenSettingLabelTextColor
{
    [self.label addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:NULL];
    self.label.textColor = [UIColor redColor];
    [self.label removeObserver:self forKeyPath:@"textColor"];
}

/**
 * Validates that KVO is triggered with appropriate value when label font property is changed.
 */
- (void)testKVOWhenSettingLabelFont
{
    [self.label addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:NULL];
    self.label.font = [UIFont fontWithName:@"Helvetica" size:2.0];
    [self.label removeObserver:self forKeyPath:@"font"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    STAssertEqualObjects(self.label, object, @"Should observe change for label");
    if ([@"text" isEqualToString:keyPath]) {
        STAssertEqualObjects([change valueForKey:NSKeyValueChangeNewKey], SOME_OTHER_TEXT,
                             @"Observed new value should be newly set label text");
    } else if ([@"textColor" isEqualToString:keyPath]) {
        STAssertEqualObjects([change valueForKey:NSKeyValueChangeNewKey], [UIColor redColor],
                             @"Observed new value should be newly set label textColor");
    } else if ([@"font" isEqualToString:keyPath]) {
        STAssertEqualObjects([change valueForKey:NSKeyValueChangeNewKey], [UIFont fontWithName:@"Helvetica" size:2.0],
                             @"Observed new value should be newly set label font");
    }
}

- (void)testNSCoding
{
    NSData *encodedLabel = [NSKeyedArchiver archivedDataWithRootObject:self.label];
    STAssertNotNil(encodedLabel, @"Archived data should not be nil");
    ORLabel *decodedLabel = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLabel];
    STAssertNotNil(decodedLabel, @"Decoded object should not be nil");
    STAssertEqualObjects(decodedLabel.identifier, self.label.identifier, @"Decoded label should have same id as original");
    STAssertEqualObjects(decodedLabel.name, self.label.name, @"Decoded label should have same name as original");
    STAssertEqualObjects(decodedLabel.text, self.label.text, @"Decoded label should have same text as original");
    STAssertEqualObjects(decodedLabel.textColor, self.label.textColor, @"Decoded label should have same textColor as original");
    STAssertEqualObjects(decodedLabel.font, self.label.font, @"Decoded label should have same font as original");
    STAssertEqualObjects(decodedLabel.definition, self.label.definition, @"Decoded label should have same definition as original");
}

@end