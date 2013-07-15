//
//  ORPanelsParser.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 15/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "ORPanelsParser.h"
#import "ORPanel.h"

@interface ORPanelsParser ()

@property (nonatomic, strong) NSData *_data;
@property (nonatomic, strong) NSMutableArray *_panels;

@end

@implementation ORPanelsParser

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self._data = data;
    }
    return self;
}

- (NSArray *)parsePanels
{
    self._panels = [NSMutableArray arrayWithCapacity:1];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	[xmlParser setDelegate:self];
	[xmlParser parse];
    
    return [NSArray arrayWithArray:self._panels];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"panel"]) {
        // TODO: take id into account
        ORPanel *panel = [[ORPanel alloc] init];
        panel.name = [attributeDict valueForKey:@"name"];
		[self._panels addObject:panel];
	}
}

@end
