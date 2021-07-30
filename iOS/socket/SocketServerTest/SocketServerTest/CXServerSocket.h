//
//  CXServerSocket.h
//  SocketServerTest
//
//  Created by chenxi on 2020/7/7.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

//https://www.jianshu.com/p/9d4a353e6682

NS_ASSUME_NONNULL_BEGIN
@protocol CXServerSocket;
@interface CXServerSocket : NSObject

@property (nonatomic, weak) id <CXServerSocket> delegate;

/// save all the connected clients.
@property (nonatomic, strong) NSMutableArray *connectedClients;

+ (instancetype)sharedIInstance;

/// create socket.
- (BOOL)creatSocket:(NSString *)host withPort:(NSInteger)port;

/// send message to all the connected client.
- (void)sendMessage:(NSString *)message;

/// send message to the specified client.
- (void)sendMessage:(NSString *)message toClient:(int)clientId;

@end

@protocol CXServerSocket <NSObject>

@optional
/// A client connect success.
- (void)socket:(CXServerSocket *)socket connectSuccess:(int)clientId;

/// A client connect fail.
- (void)socket:(CXServerSocket *)socket connectFail:(int)failCode;

/// A client disconnect.
- (void)socket:(CXServerSocket *)socket disConnect:(int)clientId;

/// Receive message from a specified client.
- (void)socket:(CXServerSocket *)socket didReceiveMessage:(NSString *)message withClient:(int)clientId;

@end

NS_ASSUME_NONNULL_END
