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

#import "ORNavigationParser.h"
#import "ORNavigation_Private.h"

@interface ORNavigationParser ()

@property (nonatomic, strong, readwrite) ORNavigation *navigation;

@end

@implementation ORNavigationParser

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        if ([attributeDict objectForKey:@"toScreen"]) {
            self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationToGroupOrScreen];
            // TODO
        } else {
            NSString *to = [[attributeDict objectForKey:@"to"] lowercaseString];
            if ([@"previousscreen" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationPreviousScreen];
            } else if ([@"nextscreen" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationNextScreen];
            } else if ([@"setting" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationSettings];
            } else if ([@"back" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationBack];
            } else if ([@"login" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationLogin];
            } else if ([@"logout" isEqualToString:to]) {
                self.navigation = [[ORNavigation alloc] initWithNavigationType:ORNavigationLogout];
            } else {
                // TODO : error
            }

        }
        
        /*
                          ]ToScreen:[[attributeDict objectForKey:@"toScreen"] intValue]
                                                   toGroup:[[attributeDict objectForKey:@"toGroup"] intValue]
         */
    }
    return self;
}

@synthesize navigation;

@end