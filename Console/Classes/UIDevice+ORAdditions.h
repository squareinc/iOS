//
// Created by Gilles Durys on 22/11/16.
// Copyright (c) 2016 OpenRemote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPAD_PRO_12;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPAD;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPAD3;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPHONE_6_PLUS;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPHONE6;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPHONE_5;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPHONE_4;
FOUNDATION_EXPORT NSString *const DEVICE_TYPE_IPHONE;

@interface UIDevice (ORAdditions)

- (NSString *)autoSelectPrefix;

+ (NSArray<NSString *> *)allAutoSelectPrefixes;

@end