//
//  CXServerSocket.m
//  SocketServerTest
//
//  Created by chenxi on 2020/7/7.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "CXServerSocket.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@interface CXServerSocket()
@property (nonatomic, assign) int serverSocketId;
@property (nonatomic, assign) int maxConnectCount;

@end

@implementation CXServerSocket

+ (instancetype)sharedIInstance {
    static CXServerSocket *_socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socket = [[CXServerSocket alloc] init];
    });
    return _socket;
}

- (instancetype)init {
    if (self = [super init]) {
        _maxConnectCount = 3;
    }
    return self;
}

- (NSMutableArray *)connectedClients {
    if (!_connectedClients) {
        _connectedClients = [NSMutableArray array];
    }
    return _connectedClients;
}

- (BOOL)creatSocket:(NSString *)host withPort:(NSInteger)port {
    if ([self creat] == NO) {
        NSLog(@"create socket fail");
        return NO;
    }
    
    if ([self bind:host withPort:port] == NO) {
        NSLog(@"bing fail");
        return NO;
    }
    
    return [self listen];
}

- (BOOL)creat {
    _serverSocketId = socket(AF_INET, SOCK_STREAM, 0);
    return _serverSocketId != -1;
}

- (BOOL)bind:(NSString *)host withPort:(NSInteger)port {
    
    if ([self creat] == NO) {
        return NO;
    }
    struct sockaddr_in addr;
    addr.sin_len = sizeof(struct sockaddr_in);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(host.UTF8String);
    bzero(&(addr.sin_zero), 8);
    
    int ret = bind(_serverSocketId, (struct sockaddr *)&addr, sizeof(addr));
    
    return (ret != -1);
}

- (BOOL)listen {
    if (listen(_serverSocketId, _maxConnectCount) == -1) {
        NSLog(@"listen fail.");
        return NO;
    }
    for (int i = 0; i < _maxConnectCount; i++) {
        [self accept:_serverSocketId];
    }
    return YES;
}

- (void)accept:(int)serverSocketId {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        struct sockaddr clientAddres;
        socklen_t addressLen;
        while (true) {
            int clientSocketId = accept(serverSocketId, (struct sockaddr *)&clientAddres, &addressLen);
            
            [self notifyClientConnect:clientSocketId];
            
            if (clientSocketId == -1) {
                NSLog(@"accept client fail, %d", clientSocketId);
            } else {
                NSLog(@"accept client success: %d", clientSocketId);
                [self sendMessage:[NSString stringWithFormat:@"connect success, id: %d", clientSocketId] toClient:clientSocketId];
                [self receiveClientMessage:clientSocketId];
            }
        }
    });
}

- (void)notifyClientConnect:(int)clientSocketId {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (clientSocketId == -1) {
            if ([self.delegate respondsToSelector:@selector(socket:connectFail:)]) {
                [self.delegate socket:self connectFail:clientSocketId];
            }
        } else {
            [self addClientSocket:clientSocketId];
            if ([self.delegate respondsToSelector:@selector(socket:connectSuccess:)]) {
                [self.delegate socket:self connectSuccess:clientSocketId];
            }
        }
    });
}

- (void)receiveClientMessage:(int)clientSocketId {
    while (true) {
        char buf[1024] = {0};
        size_t retsult = recv(clientSocketId, buf, 1024, 0);
        if (retsult > 0) {
            NSString *msg = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
            NSLog(@"receive client message: %@", msg);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(socket:didReceiveMessage:withClient:)]) {
                    [self.delegate socket:self didReceiveMessage:msg withClient:clientSocketId];
                }
            });
        } else if (retsult == 0) {
            NSLog(@"client %d out.", clientSocketId);
            [self removeClientSocket:clientSocketId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(socket:disConnect:)]) {
                    [self.delegate socket:self disConnect:clientSocketId];
                }
                
            });
            close(clientSocketId);
            break;
        } else if (retsult == -1) {
            NSLog(@"receive client msg fail: %d", clientSocketId);
        } else {
            NSLog(@"receive client: %zu", retsult);
        }
    }
}

- (void)sendMessage:(NSString *)message {
    for (NSNumber *clientId in [self connectedClients]) {
        if (clientId) {
            [self sendMessage:message toClient:[clientId intValue]];
        }
    }
}

- (void)sendMessage:(NSString *)message toClient:(int)clientId {
    if ([self isClientConnected:clientId] == NO) {
        NSLog(@"client %d not connected", clientId);
        return;
    }
    
    char *buf[1024] = {0};
    const char *p = (char *)buf;
    p = [message cStringUsingEncoding:NSUTF8StringEncoding];
    send(clientId, p, 1024, 0);
}

- (void)addClientSocket:(int)clientSocketId {
    @synchronized (self) {
        [self.connectedClients addObject:@(clientSocketId)];
    }
}

- (BOOL)isClientConnected:(int)clientSocketId {
    __block BOOL result = NO;
    @synchronized (self) {
        [self.connectedClients enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj intValue] == clientSocketId) {
                result = YES;
                *stop = YES;
            }
        }];
    }
    return result;
}

- (void)removeClientSocket:(int)clientSocketId {
    @synchronized (self) {
        [self.connectedClients removeObject:@(clientSocketId)];
    }
}
@end
