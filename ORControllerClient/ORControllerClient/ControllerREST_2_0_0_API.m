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

#import "ControllerREST_2_0_0_API.h"

#import "ORPanelsParser.h"

@implementation ControllerREST_2_0_0_API

- (void)requestPanelIdentityListAtBaseURL:(NSURL *)baseURL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[baseURL URLByAppendingPathComponent:@"/rest/panels"]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"response %@", response);
        NSLog(@"code %d", [((NSHTTPURLResponse *)response) statusCode]);
        
        ORPanelsParser *parser = [[ORPanelsParser alloc] initWithData:data];
        NSLog(@"data %@", [parser parsePanels]);

        
        NSLog(@"error %@", error);
        
        /*
         If protected resource : 
         2013-07-16 15:05:44.191 ORControllerClientSample[7289:c07] error Error Domain=NSURLErrorDomain Code=-1012 "The operation couldn’t be completed. (NSURLErrorDomain error -1012.)" UserInfo=0x889bd20 {NSErrorFailingURLKey=http://localhost:8688/controller/rest/panels, NSErrorFailingURLStringKey=http://localhost:8688/controller/rest/panels, NSUnderlyingError=0x889aaf0 "The operation couldn’t be completed. (kCFErrorDomainCFNetwork error -1012.)"}

         see URL Loading System Error Codes in https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html
         */
        
        
        // TODO: check on self signed https URL
        
    }];
    
    // TODO: check if this API can handle authentication, https, ... as we have currently in console
    // If no, then keep  "old way", maybe encapsulate for blocks, ...
}

@end
