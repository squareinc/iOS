//
//  MockImageLoaderWithNoStorageToFile.m
//  openremote
//
//  Created by Eric Bariaux on 07/10/13.
//  Copyright (c) 2013 OpenRemote, Inc. All rights reserved.
//

#import "MockImageLoaderWithNoStorageToFile.h"

@implementation MockImageLoaderWithNoStorageToFile

-(void)dealloc
{
    self.imageToReturn = nil;
    [super dealloc];
}

- (void)loadImageNamed:(NSString *)name available:(void (^)(UIImage *))availableBlock
{
    availableBlock(self.imageToReturn);
}

@end
