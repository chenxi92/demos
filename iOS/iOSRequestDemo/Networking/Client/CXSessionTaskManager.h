//
//  CXSessionTaskManager.h
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXSessionTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXSessionTaskManager : NSObject

- (void)add:(CXSessionTask *)task;

- (void)remove:(CXSessionTask *)task;

- (CXSessionTask *)getTask:(NSURLSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
