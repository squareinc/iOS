//
//  MockImageLoaderStoringToFile.m
//  openremote
//
//  Created by Eric Bariaux on 07/10/13.
//  Copyright (c) 2013 OpenRemote, Inc. All rights reserved.
//

#import "MockImageLoaderStoringToFile.h"

@implementation MockImageLoaderStoringToFile

- (void)dealloc
{
    self.imageToReturn = nil;
    [super dealloc];
}

- (void)loadImageNamed:(NSString *)name toPath:(NSString *)path available:(void (^)(void))availableBlock
{
    [UIImagePNGRepresentation(self.imageToReturn) writeToFile:path atomically:YES];
    availableBlock();
}

- (void)loadImageNamed:(NSString *)name available:(void (^)(UIImage *))availableBlock
{
    // Not available
}

@end
