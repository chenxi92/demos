//
//  CXSocket.h
//  Facebook Share
//
//  Created by chenxi on 2020/7/6.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXSocketDelegate;
@interface CXSocket : NSObject

@property (nonatomic, weak) id <CXSocketDelegate>delegate;

+ (instancetype)shareInstance;

- (BOOL)createSocket:(NSString *)host withPort:(NSString *)port;

- (void)sendMessage:(NSString *)message;

- (void)receiveMessage;

@end

@protocol CXSocketDelegate <NSObject>
@optional

- (void)socket:(CXSocket *)socket didReceiveMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
