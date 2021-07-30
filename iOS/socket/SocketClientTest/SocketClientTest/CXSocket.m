//
//  CXSocket.m
//  Facebook Share
//
//  Created by chenxi on 2020/7/6.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "CXSocket.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <sys/socket.h>

@interface CXSocket()
@property (nonatomic, assign) int clientId;
@end

@implementation CXSocket

+ (instancetype)shareInstance {
    static CXSocket *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[CXSocket alloc] init];
    });
    return socket;
}

- (BOOL)createSocket:(NSString *)host withPort:(NSString *)port {
    
    self.clientId = socket(AF_INET, SOCK_STREAM, 0);
    if (self.clientId == -1) {
        NSLog(@"create fail.");
        return NO;
    }
    
    struct hostent *remotHostEnt = gethostbyname([host UTF8String]);
    if (remotHostEnt == NULL) {
        NSLog(@"unable parse host: %@", host);
        close(self.clientId);
        return NO;
    }
            
    struct in_addr *remoteInAddr = (struct in_addr *)remotHostEnt -> h_addr_list[0];
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr   = *remoteInAddr;
    socketParameters.sin_port   = htons([port intValue]);

    int ret = connect(self.clientId, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    
    if (ret != 0) {
        close(self.clientId);
        NSLog(@"connect fail, result: %d.", ret);
        return NO;
    }
    
    NSLog(@"connect [%@:%@] success, begin receive message ...", host, port);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self receiveMessage];
    });
    return YES;
}


- (void)sendMessage:(NSString *)message {
    if (!message) return;
    
    const char *msg = message.UTF8String;
    ssize_t sendLen = send(self.clientId, msg, strlen(msg), 0);
    NSLog(@"send %ld bytes, message: %@", sendLen, message);
}


- (void)receiveMessage {
    while (true) {
        char buffer[1024];
        ssize_t recvLen = recv(self.clientId, buffer, sizeof(buffer), 0);
        
        if (recvLen < 1) continue;
        
        NSString *responseMsg = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
        NSLog(@"receive %ld bytes, message: %@", responseMsg.length, responseMsg);
        if ([self.delegate respondsToSelector:@selector(socket:didReceiveMessage:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate socket:self didReceiveMessage:responseMsg];
            });
        }
    }
}

@end
