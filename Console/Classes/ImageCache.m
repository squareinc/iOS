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
    NSString *path = [self.cachePath stringByAppendingPathComponent:name];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}

- (UIImage *)getImageNamed:(NSString *)name
{

	NSString *path = [self.cachePath stringByAppendingPathComponent:name];
	if (![FileUtils checkFileExistsWithPath:path]) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)getImageNamed:(NSString *)name finalImageAvailable:(void (^)(UIImage *))availableBlock
{
    return nil;
}

- (BOOL)isImageAvailableNamed:(NSString *)name
{
    NSString *path = [self.cachePath stringByAppendingPathComponent:name];
    return [FileUtils checkFileExistsWithPath:path];
}

- (void)forgetImageNamed:(NSString *)name
{
    NSString *path = [self.cachePath stringByAppendingPathComponent:name];
    
    // TODO: handle error
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)forgetAllImages
{
    NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cachePath error:NULL];
    for (NSString *image in images) {
        [[NSFileManager defaultManager] removeItemAtPath:[self.cachePath stringByAppendingPathComponent:image] error:NULL];
    }
}

@end
