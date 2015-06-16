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

#import "ORImage_Private.h"
#import "ORWidget_Private.h"

#define kSrcKey       @"Src"
#define kLabelKey     @"Label"

@interface ORImage ()

@property (copy, nonatomic, readwrite) NSString *src;

@end

@implementation ORImage

- (instancetype)initWithIdentifier:(ORObjectIdentifier *)anIdentifier src:(NSString *)aSrc;
{
    self = [super initWithIdentifier:anIdentifier];
    if (self) {
        self.src = aSrc;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.src forKey:kSrcKey];
    [aCoder encodeObject:self.label forKey:kLabelKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.src = [aDecoder decodeObjectForKey:kSrcKey];
        self.label = [aDecoder decodeObjectForKey:kLabelKey];
    }
    return self;
}

@synthesize src;
@synthesize label;

@end