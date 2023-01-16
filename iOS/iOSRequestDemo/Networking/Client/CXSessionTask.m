//
//  CXSessionTask.m
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import "CXSessionTask.h"

@implementation CXSessionTask

- (instancetype)initWith:(CXRequest *)request sessionTask:(NSURLSessionTask *)sessionTask {
    if (self = [super init]) {
        _request = request;
        _sessionTask = sessionTask;
    }
    return self;
}

- (void)resume {
    [self.sessionTask resume];
}

- (NSNumber *)identifier {
    return [NSNumber numberWithUnsignedInteger:self.sessionTask.taskIdentifier];
}

@end
