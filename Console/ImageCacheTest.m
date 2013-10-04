//
//  ResourceManagerTest.m
//  openremote
//
//  Created by Eric Bariaux on 03/10/13.
//  Copyright (c) 2013 OpenRemote, Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ImageCache.h"
#import "DirectoryDefinition.h"

#define IMAGE_NAME1 @"Image1"
#define IMAGE_NAME2 @"Image2"

@interface ImageCacheTest : SenTestCase

@property (nonatomic, retain) ImageCache *cache;
@property (nonatomic, retain) UIImage *image1;

@end

@implementation ImageCacheTest

- (void)setUp
{
    self.cache = [[[ImageCache alloc] initWithCachePath:[DirectoryDefinition imageCacheFolder]] autorelease];
    self.image1 = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[ImageCacheTest class]] pathForResource:@"Default" ofType:@"png"]];
}

- (void)tearDown
{
    self.image1 = nil;
    self.cache = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[DirectoryDefinition imageCacheFolder] error:NULL];
}

- (void)testInitWithNonExistentCachePath
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", arc4random()]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    ImageCache *cache = [[ImageCache alloc] initWithCachePath:path];
    STAssertNotNil(cache, @"Cache should have been created");
    BOOL isDirectory;
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory], @"Cache should have created its cache folder");
    STAssertTrue(isDirectory, @"Created cache folder should be a directory");
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)testInitWithNonExistentCachePathNoAccess
{
    NSString *parentPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", arc4random()]];
    [[NSFileManager defaultManager] createDirectoryAtPath:parentPath withIntermediateDirectories:YES attributes:@{NSFilePosixPermissions : @444} error:NULL];
    NSString *path = [parentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", arc4random()]];
    ImageCache *cache = [[ImageCache alloc] initWithCachePath:path];
    STAssertNil(cache, @"Cache should have not been created as folder creation was forbidden");
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL], @"Cache folder should not have been created");
    [[NSFileManager defaultManager] removeItemAtPath:parentPath error:NULL];
}

- (void)testInitWithExistentFolderPath
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", arc4random()]];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    ImageCache *cache = [[ImageCache alloc] initWithCachePath:path];
    STAssertNotNil(cache, @"Cache should have been created");
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)testInitWithExistentFilePath
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", arc4random()]];
    [@"test" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    ImageCache *cache = [[ImageCache alloc] initWithCachePath:path];
    STAssertNil(cache, @"Cache should have not been created as a file exists at its location");
    BOOL isDirectory;
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory], @"Cache should not have removed the existing file");
    STAssertFalse(isDirectory, @"Cache should not have changed existing file to folder");
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)testGetNonAvailableResource
{
    ImageCache *mgr = [[ImageCache alloc] init];
    STAssertNil([mgr getImageNamed:IMAGE_NAME1], @"Getting non image resource should return nil");
    STAssertFalse([mgr isImageAvailableNamed:IMAGE_NAME1], @"Non image resource should be reported as such");
    [mgr release];
}

- (void)testStoreAndRetrieveResource
{
    ImageCache *mgr = [[ImageCache alloc] init];
    [mgr storeImage:self.image1 named:IMAGE_NAME1];
    STAssertNotNil([mgr getImageNamed:IMAGE_NAME1], @"Getting existing image should not return nil");
    STAssertEqualObjects(UIImagePNGRepresentation(self.image1), UIImagePNGRepresentation([mgr getImageNamed:IMAGE_NAME1]), @"Retrieved image should be registered one");
    STAssertTrue([mgr isImageAvailableNamed:IMAGE_NAME1], @"Available image should be reported as such");
    STAssertNil([mgr getImageNamed:IMAGE_NAME2], @"Getting non available image should return nil");
    [mgr release];
}

- (void)testForgetResource
{
    ImageCache *mgr = [[ImageCache alloc] init];
    [mgr storeImage:self.image1 named:IMAGE_NAME1];
    [mgr forgetImageNamed:IMAGE_NAME1];
    STAssertNil([mgr getImageNamed:IMAGE_NAME1], @"Getting forgotten image should return nil");
    STAssertFalse([mgr isImageAvailableNamed:IMAGE_NAME1], @"Forgotten image should be reported as not available");
    [mgr release];
}

//- (void)forgetAllResources;



@end
