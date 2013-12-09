/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import <CoreData/CoreData.h>
#import "ORControllerGroupMembersFetcher.h"
#import "ORControllerCapabilitiesFetcher.h"

@class ORConsoleSettings;
@class ORGroupMember;
@class ORControllerProxy;
@class Definition;
@class SensorStatusCache;
@class ClientSideRuntime;
@class Capabilities;

@class ORController;

// TODO: do we really need to have those different notifications, can't we just pass the status as param to the notification

extern NSString *kORControllerGroupMembersFetchingNotification;
extern NSString *kORControllerGroupMembersFetchSucceededNotification;
extern NSString *kORControllerGroupMembersFetchFailedNotification;
extern NSString *kORControllerGroupMembersFetchRequiresAuthenticationNotification;

extern NSString *kORControllerCapabilitiesFetchStatusChange;
extern NSString *kORControllerPanelIdentitiesFetchStatusChange;

enum {
    FetchStatusUnknown = 0,
	Fetching,
    FetchSucceeded,
    FetchFailed,
    FetchRequiresAuthentication
};
typedef NSInteger ORControllerFetchStatus;


@interface ORControllerConfig : NSManagedObject <ORControllerGroupMembersFetcherDelegate, ORControllerCapabilitiesFetcherDelegate> {
@private
    ORGroupMember *__weak activeGroupMember;
    ORControllerProxy *proxy;
    ORControllerFetchStatus groupMembersFetchStatus;
}

@property (nonatomic, strong) NSString * primaryURL;
@property (nonatomic, strong) NSString *selectedPanelIdentity;
@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSSet* groupMembers;
@property (nonatomic, strong) ORConsoleSettings * settingsForControllers;
@property (nonatomic, strong) ORConsoleSettings * settingsForSelectedController;

@property (weak, nonatomic, readonly) NSString *selectedPanelIdentityDisplayString;

@property (nonatomic, weak) ORGroupMember *activeGroupMember;

@property (nonatomic, strong) Capabilities *capabilities;
@property (nonatomic, strong) NSString *controllerAPIVersion;
@property (nonatomic, strong) NSArray *panelIdentities;

@property (nonatomic, readonly, strong) ORControllerProxy *proxy;

@property (nonatomic, readonly, strong) ORController *controller;

@property (nonatomic, readonly) ORControllerFetchStatus groupMembersFetchStatus;
@property (nonatomic, readonly) ORControllerFetchStatus capabilitiesFetchStatus;
@property (nonatomic, readonly) ORControllerFetchStatus panelIdentitiesFetchStatus;

- (void)fetchGroupMembers;
- (void)cancelGroupMembersFetch;

- (void)fetchCapabilities;

- (void)fetchPanels;

- (void)addGroupMemberForURL:(NSString *)url;

- (BOOL)hasGroupMembers;
- (BOOL)hasCapabilities;
- (BOOL)hasPanelIdentities;

// TODO: re-check in model vs property
// TODO: this is not persisted but should be lazy loaded (! parsing is required -> we want to be able to notifiy user of progress and let him cancel)
@property (nonatomic, strong) Definition *definition;

@property (nonatomic, strong, readonly) SensorStatusCache *sensorStatusCache;
@property (nonatomic, strong, readonly) ClientSideRuntime *clientSideRuntime;

@end