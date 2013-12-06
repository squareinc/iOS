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

#import <Foundation/Foundation.h>
#import "ORCredential.h"

/**
 * ORCredential implementation using username and password as the authentication mean.
 */
@interface ORUserPasswordCredential : NSObject <ORCredential>

/**
 * Initializes an ORUserPasswordCredential instance with the given username and password.
 *
 * @param username The user for the credential
 * @param password The password for the user
 *
 * @return an ORUserPasswordCredential instance initialized with the given username and password
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
