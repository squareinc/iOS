//
//  SensorStatusCache.m
//  openremote
//
//  Created by Eric Bariaux on 04/05/12.
//  Copyright (c) 2012 OpenRemote, Inc. All rights reserved.
//

#import "SensorStatusCache.h"
#import "NotificationConstant.h"
#import "ORObjectIdentifier.h"

@interface SensorStatusCache()

@property (nonatomic, strong) NSMutableDictionary *statusCache;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@end

@implementation SensorStatusCache

- (id)initWithNotificationCenter:(NSNotificationCenter *)aNotificationCenter
{
    self = [super init];
    if (self) {
        self.statusCache = [NSMutableDictionary dictionary];
        self.notificationCenter = aNotificationCenter;
    }
    return self;
}


- (void)publishNewValue:(NSString *)status forSensorIdentifier:(ORObjectIdentifier *)sensorIdentifier
{
    [self.statusCache setObject:status forKey:sensorIdentifier];
    [self.notificationCenter postNotificationName:[NSString stringWithFormat:NotificationPollingStatusIdFormat, sensorIdentifier] object:self];
}

- (NSString *)valueForSensorIdentifier:(ORObjectIdentifier *)sensorIdentifier
{
    return [self.statusCache objectForKey:sensorIdentifier];
}

- (void)clearStatusCache
{
    [self.statusCache removeAllObjects];
}

@synthesize statusCache;
@synthesize notificationCenter;

@end