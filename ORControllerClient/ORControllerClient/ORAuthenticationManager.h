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

@protocol ORCredential;

/**
 * An authentication manager is responsible for providing credentials to be used
 * when communicating with an OR controller that does require some form of authentication.
 */
@protocol ORAuthenticationManager <NSObject>

/**
 * This methods gets called when, during communication with an OR controller,
 * some authentication is required.
 *
 * The authentication manager must in return provide credential that will be used
 * to retry the call.
 * If the provided credential does not provide access, this method will be called again.
 * Returning nil indicates that the communication must proceed without credential,
 * potentially leading to a communication error caused by un-authorized access.
 *
 * It is guaranteed that this method will be called on a thread other than the main thread,
 * potentially allowing the authentication manager to block while retrieving the credential
 * (e.g. if asking to the user).
 *
 * @return ORCredential credential to use for communication
 */
- (NSObject <ORCredential> *)credential;

@end
