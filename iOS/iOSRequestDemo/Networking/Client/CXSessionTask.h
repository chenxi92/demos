//
//  CXSessionTask.h
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXSessionTask : NSObject

@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic, strong) CXRequest *request;

@property (nonatomic, assign) dispatch_queue_t callbackQueue;

@property (nonatomic, copy) void (^callback)(NSError * _Nullable error, NSDictionary * _Nullable response);

@property (nonatomic, strong, readonly) NSNumber *identifier;

- (instancetype)initWith:(CXRequest *)request sessionTask:(NSURLSessionTask *)sessionTask;

- (void)resume;

@end

NS_ASSUME_NONNULL_END
