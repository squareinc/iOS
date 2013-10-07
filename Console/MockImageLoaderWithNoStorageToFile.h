//
//  MockImageLoaderWithNoStorageToFile.h
//  openremote
//
//  Created by Eric Bariaux on 07/10/13.
//  Copyright (c) 2013 OpenRemote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"

@interface MockImageLoaderWithNoStorageToFile : NSObject <ImageCacheLoader>

@property (nonatomic, retain) UIImage *imageToReturn;

@end
