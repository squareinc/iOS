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

#import "UIDevice+UDID.h"

@implementation UIDevice (UDID)

// Code coming from http://stackoverflow.com/questions/18868576/udid-replacement-in-ios7
// No license specified, considered public domain
- (NSString *)uniqueID
{
    NSString *uniqueIdentifier = nil;
    if ([UIDevice instancesRespondToSelector:@selector(identifierForVendor)]) {
        // iOS 6+
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        // before iOS 6, so just generate an identifier and store it
        uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"identiferForVendor"];
        if (!uniqueIdentifier) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            uniqueIdentifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
            CFRelease(uuid);
            [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"identifierForVendor"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return uniqueIdentifier;
}

@end