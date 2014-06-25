/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
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

#import "ORControllerBrowser.h"
#import "ORControllerInfo.h"
#import "ORControllerAddress.h"
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

static long socketIdentifier = 1;

// Value should not be too small to allow a discovery round to happen
// even with slow network / controllers
#define INITIAL_BROADCAST_INTERVAL  8.0

@interface ORControllerBrowser () <AsyncUdpSocketDelegate, AsyncSocketDelegate>

@property (nonatomic, strong) NSMutableDictionary *controllerCache;

@property (nonatomic, readwrite, getter = isSearching) BOOL searching;

@property (nonatomic, strong) AsyncSocket *serverSocket;

@property (nonatomic, strong) NSMutableArray *clientSockets;
@property (nonatomic, strong) NSMutableDictionary *clientReadBuffers;

@property (nonatomic, strong) AsyncUdpSocket *broadcastSocket;

@property (nonatomic) NSTimeInterval broadcastInterval;
@property (nonatomic, strong) NSTimer *broadcastTimer;

@property (nonatomic, readonly) NSTimeInterval communicationTimeout;

@end

/*
 * This class keeps track of client sockets established with controllers.
 * It assigns them a unique identifier (long) to link to socket with associated data.
 * A read buffer to accumulate information received from the controller is such a data.
 */
@implementation ORControllerBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.controllerCache = [NSMutableDictionary dictionary];
        self.clientSockets = [NSMutableArray array];
        self.clientReadBuffers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [self stopSearchingForORControllers];
}

- (void)startSearchingForORControllers
{
    if (!self.searching) {
        self.serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
		UInt16 serverPort = 2346;

        NSError *error;
        if (![self.serverSocket acceptOnPort:serverPort error:&error]) {
            if ([self.delegate respondsToSelector:@selector(controllerBrowser:didFail:)]) {
                // TODO: encapsulate error in our own domain
                [self.delegate controllerBrowser:self didFail:error];
            }
        }
    }

    self.broadcastSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];

    self.searching = YES;
    
    self.broadcastInterval = INITIAL_BROADCAST_INTERVAL;

    [self broadcastAutodiscoveryPacket];
    
    [self.broadcastTimer invalidate];
    self.broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:self.broadcastInterval target:self selector:@selector(broadcast:) userInfo:NULL repeats:NO];
}

- (void)stopSearchingForORControllers
{
    [self.broadcastTimer invalidate];
    self.broadcastTimer = nil;

    [self.broadcastSocket close];
    self.broadcastSocket = nil;

    [self.clientSockets makeObjectsPerformSelector:@selector(disconnect)];
    [self.clientSockets removeAllObjects];
    [self.clientReadBuffers removeAllObjects];
    
    [self.serverSocket disconnect];
    self.serverSocket = nil;
    
    self.searching = NO;
}

- (NSArray *)discoveredControllers
{
    return [self.controllerCache allValues];
}

- (void)broadcast:(NSTimer *)timer
{
    [self.broadcastTimer invalidate];
    [self broadcastAutodiscoveryPacket];
    self.broadcastInterval = MIN(3600.0, self.broadcastInterval * 2.0);
    self.broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:self.broadcastInterval target:self selector:@selector(broadcast:) userInfo:NULL repeats:NO];
}

- (void)broadcastAutodiscoveryPacket
{
    NSLog(@"Broadcast autodiscovery packet");
    NSData *d = [@"openremote" dataUsingEncoding:NSUTF8StringEncoding];
    // Multicast IP
    NSString *host = @"224.0.1.100";
    // Multicast port
    UInt16 port = 3333;
    
    [self.broadcastSocket sendData:d toHost:host port:port withTimeout:self.communicationTimeout tag:0];
}

#pragma mark - UDPSocket delegate methods

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"DidNotSend: %@", error);
    
    // TODO:
//	[self onFindServerFail:[error localizedDescription]];
}

#pragma mark - TCPSocket delegate methods

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	NSLog(@"receive new socket %@", newSocket);

    // new socket must be retained to be able to handle connection
	[self.clientSockets addObject:newSocket];
    
    // also set some unique identifier on the socket, to keep track of associated objects
    [newSocket setUserData:[self nextSocketIdentifier]];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"received data from server %@", data);
    
    // Only interested in client sockets we're "tracking"
    if (![self.clientSockets containsObject:sock]) {
        return;
    }
    
    [[self readBufferForSocket:sock] appendData:data];

    // Trigger an additional read, to either get rest of data or receive "socket close information".
    // As the server implementation closes the socket when done sending the required information,
    // we use that to indicate the "end of packet" and process what we received.
    // We thus want to continue reading to make sure we receive the notification that socket closed.
    [sock readDataWithTimeout:self.communicationTimeout tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"receive socket %@ host %@ port %d", sock, host, port);

    // Only interested in client sockets we're "tracking"
    if (![self.clientSockets containsObject:sock]) {
        return;
    }

    // Connection has been established with a client socket, start reading
    [sock readDataWithTimeout:self.communicationTimeout tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"socket %@ will disconnect, error %@", sock, err);

    // Only interested in client sockets we're "tracking"
    if (![self.clientSockets containsObject:sock]) {
        return;
    }

    // TODO: handle error
    
    // Make sure we collect any pending data
    [[self readBufferForSocket:sock] appendData:sock.unreadData];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Socket did disconnect %@", sock);

    // Only interested in client sockets we're "tracking"
    if (![self.clientSockets containsObject:sock]) {
        return;
    }

    // We now can process all data we read
    NSString *serverUrl = [[NSString alloc] initWithData:[self readBufferForSocket:sock] encoding:NSUTF8StringEncoding];
	NSLog(@"read server url from controller %@", serverUrl);

    ORControllerInfo *info = [self.controllerCache objectForKey:serverUrl];
    if (!info) {
        info = [[ORControllerInfo alloc] initWithIdentifier:serverUrl];
        info.name = serverUrl;
        info.address = [[ORControllerAddress alloc] initWithPrimaryURL:[NSURL URLWithString:serverUrl]];
        [self.controllerCache setObject:info forKey:serverUrl];
        if ([self.delegate respondsToSelector:@selector(controllerBrowser:didFindController:)]) {
            [self.delegate controllerBrowser:self didFindController:info];
        }
    }
    
    [self.clientReadBuffers removeObjectForKey:[NSNumber numberWithLong:sock.userData]];
    [self.clientSockets removeObject:sock];
}

#pragma mark Helper methods

/**
 * Returns timeout value to use for read/write operations on sockets.
 *
 * We use a timeout value is appropriate for the current broadcast interval,
 * so that communications would not overlap with next broadcast,
 * but still cap it to resonable value.
 */
- (NSTimeInterval)communicationTimeout
{
    return MAX((self.broadcastInterval / 4.0), 60.0);
}

/**
 * Returns a unique identifier to assign the new sockets.
 * Guaranteed to be unique over lifetime of application.
 * This implementation simply use a sequence.
 */
- (long)nextSocketIdentifier
{
    return ++socketIdentifier;
}

/**
 * Returns an NSMutableData buffer that is used for reading data on the given socket.
 */
- (NSMutableData *)readBufferForSocket:(AsyncSocket *)sock
{
    // Get the read buffer to accumulate read data in
    NSMutableData *readBuffer = [self.clientReadBuffers objectForKey:[NSNumber numberWithLong:sock.userData]];
    if (!readBuffer) {
        readBuffer = [NSMutableData data];
        [self.clientReadBuffers setObject:readBuffer forKey:[NSNumber numberWithLong:sock.userData]];
    }
    return readBuffer;
}

@end
