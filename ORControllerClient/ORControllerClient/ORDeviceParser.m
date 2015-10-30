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

#import "ORDeviceParser.h"
#import "ORDevice_Private.h"
#import "ORParser_Private.h"
#import "ORObjectIdentifier.h"
#import "ORCommand.h"
#import "ORCommand_Private.h"

@interface ORDeviceParser ()

@end

@implementation ORDeviceParser

- (ORDevice *)parseDevice
{
    if (![self doParsing]) {
        return nil;
    }

    return self.device;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"device"]) {
        self.device.name = [attributeDict valueForKey:@"name"];
        self.device.identifier = [[ORObjectIdentifier alloc] initWithStringId:[attributeDict valueForKey:@"id"]];
    } else if ([elementName isEqualToString:@"command"]) {
        ORCommand *command = [[ORCommand alloc] init];
        command.identifier = [[ORObjectIdentifier alloc] initWithStringId:[attributeDict valueForKey:@"id"]];
        command.name = attributeDict[@"name"];
        command.protocol = attributeDict[@"protocol"];
        [self.device.internalCommands addObject:command];
    }
}

@end
