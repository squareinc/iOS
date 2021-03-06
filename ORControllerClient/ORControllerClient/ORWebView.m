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
#import "ORWebView_Private.h"
#import "ORWidget_Private.h"

#define kSrcKey       @"Src"
#define kUsernameKey  @"Username"
#define kPasswordKey  @"Password"

@interface ORWebView ()

@property (nonatomic, copy, readwrite) NSString *src;
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *password;

@end

@implementation ORWebView

- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier src:(NSString *)aSrc username:(NSString *)aUsername password:(NSString *)aPassword
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.src = aSrc;
        self.username = aUsername;
        self.password = aPassword;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.src forKey:kSrcKey];
    [aCoder encodeObject:self.username forKey:kUsernameKey];
    [aCoder encodeObject:self.password forKey:kPasswordKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.src = [aDecoder decodeObjectForKey:kSrcKey];
        self.username = [aDecoder decodeObjectForKey:kUsernameKey];
        self.password = [aDecoder decodeObjectForKey:kPasswordKey];
    }
    return self;
}

@synthesize src, username, password;

@end