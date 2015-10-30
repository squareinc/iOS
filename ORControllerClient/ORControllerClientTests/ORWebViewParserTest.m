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

#import "ORWebViewParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "DefinitionParserMock.h"
#import "ORWebViewParser.h"
#import "ORSensorLinkParser.h"
#import "ORSensorStateParser.h"
#import "ORObjectIdentifier.h"

@implementation ORWebViewParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    [depRegistry registerParserClass:[ORWebViewParser class] endSelector:@selector(setTopLevelParser:) forTag:WEB];
    [depRegistry registerParserClass:[ORSensorLinkParser class] endSelector:@selector(endSensorLinkElement:) forTag:LINK];
    [depRegistry registerParserClass:[ORSensorStateParser class] endSelector:@selector(endSensorStateElement:) forTag:STATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:WEB];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    return parser.topLevelParser;
}

- (ORWebView *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    XCTAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    XCTAssertTrue([topLevelParser isMemberOfClass:[ORWebViewParser class]], @"Parser used should be an ORWebViewParser");
    ORWebView *webView = ((ORWebViewParser *)topLevelParser).web;
    XCTAssertNotNil(webView, @"A web view should be parsed for given XML snippet");
    
    return webView;
}

- (void)testParseWebViewNoUserNoSensor
{
    ORWebView *webView = [self parseValidXMLSnippet:@"<web id=\"10\" src=\"url\"/>"];
    
    XCTAssertEqualObjects(webView.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed web view should have 10 as identifer");
    
    XCTAssertEqualObjects(webView.src, @"url", @"Parsed web view should have 'url' as src property");
    XCTAssertNil(webView.username, @"Parsed web view should not have a user name defined");
    XCTAssertNil(webView.password, @"Parsed web view should not have a password defined");
}

- (void)testParseWebViewUsernamePasswordNoSensor
{
    ORWebView *webView = [self parseValidXMLSnippet:@"<web id=\"10\" src=\"url\" username=\"usr\" password=\"pwd\"/>"];
    
    XCTAssertEqualObjects(webView.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed web view should have 10 as identifer");
    
    XCTAssertEqualObjects(webView.src, @"url", @"Parsed web view should have 'url' as src property");
    XCTAssertEqualObjects(webView.username, @"usr", @"Parsed web view should have 'usr' as username");
    XCTAssertEqualObjects(webView.password, @"pwd", @"Parsed web view should have 'pwd' as password");
}

- (void)testParseWebViewUsernamePasswordWithSensor
{
    ORWebView *webView = [self parseValidXMLSnippet:@"<web id=\"10\" src=\"url\" username=\"usr\" password=\"pwd\"><link type=\"sensor\" ref=\"3\"/></web>"];
    
    XCTAssertEqualObjects(webView.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:10], @"Parsed web view should have 10 as identifer");
    
    XCTAssertEqualObjects(webView.src, @"url", @"Parsed web view should have 'url' as src property");
    XCTAssertEqualObjects(webView.username, @"usr", @"Parsed web view should have 'usr' as username");
    XCTAssertEqualObjects(webView.password, @"pwd", @"Parsed web view should have 'pwd' as password");
}

@end