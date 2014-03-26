//
//  SensorStatusCache.h
//  openremote
//
//  Created by Eric Bariaux on 04/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORObjectIdentifier;

@interface SensorStatusCache : NSObject

- (id)initWithNotificationCenter:(NSNotificationCenter *)aNotificationCenter;

- (void)publishNewValue:(NSString *)status forSensorIdentifier:(ORObjectIdentifier *)sensorIdentifier;
- (NSString *)valueForSensorIdentifier:(ORObjectIdentifier *)sensorIdentifier;
- (void)clearStatusCache;

@end