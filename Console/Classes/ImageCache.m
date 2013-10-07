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

#import "ImageCache.h"
#import "FileUtils.h"

@interface ImageCache ()

/**
 * Returns full path to cached file for a given image name.
 */
- (NSString *)cacheFilePathForName:(NSString *)name;

@property (nonatomic, retain) NSString *cachePath;

@end

@implementation ImageCache

- (id)initWithCachePath:(NSString *)path
{
    self = [super init];
    if (self) {
        BOOL isDirectory;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        
        if (!fileExists) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
                return nil;
            }
            
        } else {
            if (!isDirectory) {
                return nil;
            }
        }
        self.cachePath = path;
    }
    return self;
}

- (void)dealloc
{
    self.loader = nil;
    self.cachePath = nil;
    [super dealloc];
}


// TODO: will fail if not image -> should inform user about it -> return NO ? exception ?
- (void)storeImage:(UIImage *)image named:(NSString *)name
{
    [UIImagePNGRepresentation(image) writeToFile:[self cacheFilePathForName:name] atomically:YES];
}

- (UIImage *)getImageNamed:(NSString *)name
{
	NSString *path = [self cacheFilePathForName:name];
	if (![FileUtils checkFileExistsWithPath:path]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)getImageNamed:(NSString *)name finalImageAvailable:(void (^)(UIImage *))availableBlock
{
    if ([self isImageAvailableNamed:name]) {
        return [self getImageNamed:name];
    }
    if (self.loader) {
        if ([self.loader respondsToSelector:@selector(loadImageNamed:toPath:available:)]) {
            [self.loader loadImageNamed:name toPath:[self cacheFilePathForName:name] available:^{
                availableBlock([self getImageNamed:name]);
            }];
        } else if ([self.loader respondsToSelector:@selector(loadImageNamed:available:)]) {
            [self.loader loadImageNamed:name available:^(UIImage *image) {
                [self storeImage:image named:name];
                availableBlock(image);
            }];
        } else {
            // TODO: should there be an error if loader can not provide image ? -> at least should be logged
        }
    }
    return nil;
}

- (BOOL)isImageAvailableNamed:(NSString *)name
{
    return [FileUtils checkFileExistsWithPath:[self cacheFilePathForName:name]];
}

- (void)forgetImageNamed:(NSString *)name
{
    // TODO: handle error -> later, will have to log
    
    [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePathForName:name] error:NULL];
}

- (void)forgetAllImages
{
    NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cachePath error:NULL];
    for (NSString *image in images) {
        [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePathForName:image] error:NULL];
    }
}

- (NSString *)cacheFilePathForName:(NSString *)name
{
    return [self.cachePath stringByAppendingPathComponent:name];
}

@end
