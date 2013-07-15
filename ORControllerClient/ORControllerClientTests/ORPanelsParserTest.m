//
//  ORPanelsParserTest.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORPanelsParserTest.h"
#import "ORPanelsParser.h"
#import "ORPanel.h"

@implementation ORPanelsParserTest

- (void)testValidResponseParsing
{
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"RequestPanelIdentityListValidResponse" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
    NSArray *panels = [parser parsePanels];
    
    STAssertNotNil(panels, @"Should provide list of panels when passed in valid data");
    STAssertEquals([panels count], (NSUInteger)3, @"Fixture declares 3 panels");
    for (ORPanel *panel in panels) {
        STAssertTrue([panel isKindOfClass:[ORPanel class]], @"Elements of the returned array should be ORPanel objects");
    }
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:0]).name,
                         @"Dad's iPhone",
                         @"Name of first panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:1]).name,
                         @"Mom's iPad",
                         @"Name of second panel should be equal to the one defined in the fixture");
    STAssertEqualObjects(((ORPanel *)[panels objectAtIndex:2]).name,
                         @"My iPod touch",
                         @"Name of third panel should be equal to the one defined in the fixture");
}

@end
