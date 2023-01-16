//
//  CXSessionTaskManager.m
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import "CXSessionTaskManager.h"

@interface CXSessionTaskManager()
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, CXSessionTask *> *tasks;
@property (nonatomic, strong) NSLock *lock;
@end


@implementation CXSessionTaskManager

- (instancetype)init {
    if (self = [super init]) {
        _tasks = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)add:(CXSessionTask *)task {
    [self.lock lock];
    [self.tasks setObject:task forKey:task.identifier];
    [self.lock unlock];
}

- (void)remove:(CXSessionTask *)task {
    [self.lock lock];
    [self.tasks removeObjectForKey:task.identifier];
    [self.lock unlock];
}

- (CXSessionTask *)getTask:(NSURLSessionTask *)task {
    [self.lock lock];
    CXSessionTask *sessionTask = [self.tasks objectForKey:[NSNumber numberWithUnsignedInteger:task.taskIdentifier]];
    [self.lock unlock];
    return sessionTask;
}

@end
