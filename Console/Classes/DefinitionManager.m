/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "DefinitionManager.h"
#import "FileUtils.h"
#import "ServerDefinition.h"
#import "DirectoryDefinition.h"
#import "StringUtils.h"
#import "ViewHelper.h"
#import "NotificationConstant.h"
#import "CheckNetwork.h"
#import "ORControllerClient/PanelDefinitionParser.h"
#import "ORControllerConfig.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORController.h"
#import "ImageCache.h"

// Maximum number of operations executed concurrently
#define MAX_CONCURRENT_OPERATIONS   3

@interface DefinitionManager ()

/**
 * Parses the XML panel configuration file at the provided path and populates the receiver with the parsed configuration.
 *
 * @param NSString * full path of the XML file containing the panel configuration to parse
 */
- (void)parsePanelConfigurationFileAtPath:(NSString *)configurationFilePath;

- (void)postNotificationToMainThread:(NSString *)notificationName;
- (void)downloadXml;
- (void)parseXMLData;
- (void)downloadImages;
- (void)downloadImageWithName:(NSString *)imageName;
- (void)addDownloadImageOperationWithImageName:(NSString *)imageName;
- (BOOL)canUseLocalCache;
- (void)parseXml;
- (void)changeLoadingMessage:(NSString *)msg;

@property (nonatomic, weak) ORControllerConfig *controller;

@end

@implementation DefinitionManager

- (id)initWithController:(ORControllerConfig *)aController
{
    self = [super init];
    if (self) {
        self.controller = aController;
    }
    return self;
}

- (void)dealloc
{
    self.controller = nil;
    self.imageCache = nil;
}

// For now, take all the functionality that is about loading / triggering parsing / caching ... the definition
// from the Definition class and bring it here

- (BOOL)canUseLocalCache {
	return [[NSFileManager defaultManager] fileExistsAtPath:[[DirectoryDefinition xmlCacheFolder] stringByAppendingPathComponent:[StringUtils parsefileNameFromString:[ServerDefinition panelXmlRESTUrlForController:self.controller]]]];
}


- (void)update {
    if (isUpdating) {
		return;
	}
	isUpdating = YES;

	updateOperationQueue = [[NSOperationQueue alloc] init];
    updateOperationQueue.maxConcurrentOperationCount = MAX_CONCURRENT_OPERATIONS;
	updateOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postNotificationToMainThread:) object:DefinitionUpdateDidFinishNotification];
	
	//define Operations
	NSInvocationOperation *downloadXmlOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadXml) object:nil];
	NSInvocationOperation *parseXmlOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseXMLData) object:nil];
	
	//define Operation dependency and add it to OperationQueue
	[parseXmlOperation addDependency:downloadXmlOperation];
	[updateOperationQueue addOperation:parseXmlOperation];
	
	[updateOperation addDependency:parseXmlOperation];
	
    
    [self.controller.controller connectWithSuccessHandler:^{
        [self.controller.controller requestPanelUILayout:self.controller.selectedPanelIdentity successHandler:^(Definition *definition) {
            self.controller.definition = definition;
            
            // For now, once done, trigger download again so "old mechanism" and image download will happen
            [updateOperationQueue addOperation:downloadXmlOperation];
        } errorHandler:^(NSError *error) {
            // TODO
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideLoading object:nil];
            [self postNotificationToMainThread:DefinitionUpdateDidFinishNotification];
            [self connection:nil didFailWithError:error];
        }];
    } errorHandler:^(NSError *error) {
        // TODO
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHideLoading object:nil];
        [self postNotificationToMainThread:DefinitionUpdateDidFinishNotification];
        [self connection:nil didFailWithError:error];
    }];
    
    // TODO - EBR : check what needs to be added to queue e.g. updateOperation is not here
    // updateOperation added to queue in parseXMLData method, why ?
}

- (void)changeLoadingMessage:(NSString *)msg {
	if (loading) {
		//[loading setText:msg];
	}
}

- (void)useLocalCacheDirectly {
	if ([self canUseLocalCache]) {
		[self parseXml];
	} else {
		//		[ViewHelper showAlertViewWithTitle:@"Error" Message:@"Can't find local cache, you need to connect network and retry."];
		[[NSNotificationCenter defaultCenter] postNotificationName:DefinationNeedNotUpdate object:nil];
	}
	
}

#pragma mark Operation Tasks
- (void)downloadXml {
	NSLog(@"start download xml");
	[self changeLoadingMessage:@"download panel.xml ..."];
	NSLog(@"download panel.xml from %@", [ServerDefinition panelXmlRESTUrlForController:self.controller]);
	[FileUtils downloadFromURL:[ServerDefinition panelXmlRESTUrlForController:self.controller]
                          path:[DirectoryDefinition xmlCacheFolder]
                 forController:self.controller];
	NSLog(@"xml file downloaded.");
}

- (void)downloadImageWithName:(NSString *)imageName {
	NSString *path = [self.imageCache cacheFilePathForName:imageName];
	if ([FileUtils checkFileExistsWithPath:path] == NO) {
		NSString *msg = [[NSMutableString alloc] initWithFormat:@"download %@...", imageName];
		[self changeLoadingMessage:msg];
		NSLog(@"%@", msg);
		[FileUtils downloadFromURL:[[ServerDefinition imageUrlForController:self.controller] stringByAppendingPathComponent:imageName]
                              path:[DirectoryDefinition imageCacheFolder]
                     forController:self.controller];
	}
}

- (void)parsePanelConfigurationFileAtPath:(NSString *)configurationFilePath
{
    PanelDefinitionParser *parser = [[PanelDefinitionParser alloc] init];
    NSData *data = [[NSData alloc] initWithContentsOfFile:configurationFilePath];
    self.controller.definition = [parser parseDefinitionFromXML:data];
    
    [self.controller.controller attachPanelDefinition:self.controller.definition];
}

- (void)parseXml
{
    [self parsePanelConfigurationFileAtPath:[[DirectoryDefinition xmlCacheFolder] stringByAppendingPathComponent:self.controller.selectedPanelIdentity]];
}

//Parses xml
- (void)parseXMLData {
//	[self parseXml]; // Don't parse XML anymore, already been done by requestPanel call on ORController
	[self downloadImages];
	NSLog(@"images download done");
	
	//after parse the xml all the Operation have already added to OperationQuere and addDependency to updateOperation
	[updateOperationQueue addOperation:updateOperation];
	NSLog(@"parse xml end element screens and add updateOperation to queue");
}

- (void)downloadImages {
	@try {
        // TODO: why that check at this stage
        // This might have been to only download images on WiFi, not cellular
        // Get rid of this for now, will check how to implement that better in the future
//		[CheckNetwork checkWhetherNetworkAvailable];
		
		for (NSString *imageName in self.controller.definition.imageNames) {
			if (imageName) {
				[self addDownloadImageOperationWithImageName:imageName];
			}				
		}
		
	}
	@catch (NSException * e) {
		[ViewHelper showAlertViewWithTitle:@"Error" Message:@"Can't download image from Server, there is no network."];
	}		
}

- (void)addDownloadImageOperationWithImageName:(NSString *)imageName {
	NSInvocationOperation *downloadControlIconOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageWithName:) object:imageName];
	[updateOperation addDependency:downloadControlIconOperation];
	[updateOperationQueue addOperation:downloadControlIconOperation];
}


//Shows alertView when url connection failtrue
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR OCCUR" message:error.localizedDescription  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark post notification 
//post the notification to Main thread
- (void) postNotificationToMainThread:(NSString *)notificationName {
	NSLog(@"start post notification to main thread");
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notificationName waitUntilDone:NO];
	
	isUpdating = NO;
}

//create a NSNotification and add it to NSNotificationQueue
- (void) postNotification:(NSString *)notificationName {
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self ];
	NSLog(@"post nofication done");
}

@synthesize isUpdating, loading;

@end