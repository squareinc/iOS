//
//  StatusValuesParser_2_0_0.m
//  ORControllerClient
//
//  Created by Eric Bariaux on 31/07/13.
//  Copyright (c) 2013 OpenRemote. All rights reserved.
//

#import "StatusValuesParser_2_0_0.h"

@interface StatusValuesParser_2_0_0 ()

@property (nonatomic, strong) NSData *_data;
@property (nonatomic, strong) NSMutableDictionary *_sensorValues;

@property (nonatomic, strong) NSMutableString *_currentValue;
@property (nonatomic, copy) NSString *_currentId;

@end

@implementation StatusValuesParser_2_0_0

- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self._data = data;
    }
    return self;
}

- (NSDictionary *)parseValues
{
    self._sensorValues = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	[xmlParser setDelegate:self];
	[xmlParser parse];
    
    return [NSDictionary dictionaryWithDictionary:self._sensorValues];
}

#pragma mark delegate method of NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"status"]) {
		self._currentId = [[attributeDict valueForKey:@"id"] copy];
        self._currentValue = [NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self._currentValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"status"]) {
        // TODO: why the trimming, if appropriate -> must be documented in API
        NSString *status = [self._currentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (self._currentId) {
            [self._sensorValues setObject:status forKey:self._currentId];
        }
    }
}

@end
