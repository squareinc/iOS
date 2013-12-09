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

@protocol ImageCacheLoader <NSObject>

@optional

/**
 * Go and load asynchronously the image with the given name, storing it at the given path.
 * Once the image is available, notify using callback block.
 *
 * This is the prefered method to populate the cache, as it avoids unnecessary file manipulations.
 */
- (void)loadImageNamed:(NSString *)name toPath:(NSString *)path available:(void (^)(void))availableBlock;

/**
 * Go and load asynchronously the image with the given name.
 * Once the image is available, provide it through the callback block.
 */
- (void)loadImageNamed:(NSString *)name available:(void (^)(UIImage *))availableBlock;

@end

/**
 * Manages a set of resources, storing them in a persistent way.
 * Resources not yet known to the manager are automatically fetch using a loader.
 */
@interface ImageCache : NSObject

/**
 * Initializes the image cache, indicating folder where images should be persisted.
 * If folder does not exist, it (and all required paths level) will get created.
 * If creation fails, nil is returned.
 * If a file exists at the given path, nil is returned.
 */
- (id)initWithCachePath:(NSString *)path;

/**
 * Stores the given image under the given name.
 * If an image with the given name already exists, it is replaced.
 */
- (void)storeImage:(UIImage *)image named:(NSString *)name;

/**
 * Returns the image with the given name.
 * If no image has been stored under that name,
 * returns the default image if one has been set or nil otherwise.
 */
- (UIImage *)getImageNamed:(NSString *)name;

/**
 * Immediately returns the image with the given name if available.
 * If no image has been stored under that name,
 * returns the default image if one has been set or nil otherwise.
 * If a loader has been set, asks the loader to get the image.
 * Once loader returns the image, it is stored in the manager and
 * the availableBlock is called with that image.
 */
- (UIImage *)getImageNamed:(NSString *)name finalImageAvailable:(void (^)(UIImage *))availableBlock;

/**
 * Indicates if a resource with the given name is readily available.
 */
- (BOOL)isImageAvailableNamed:(NSString *)name;

/**
 * Forgets the image with the given name.
 */
- (void)forgetImageNamed:(NSString *)name;

/**
 * Forget all the known images.
 */
- (void)forgetAllImages;

/**
 * Returns full path to cached file for a given image name.
 */
- (NSString *)cacheFilePathForName:(NSString *)name;

/**
 * Loader to use to get not yet registered images.
 */
@property (nonatomic, strong) NSObject<ImageCacheLoader> *loader;

@end
