//
//  CXSession.m
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import "CXSession.h"
#import "CXSessionTaskManager.h"

@interface CXSession()
@property (nonatomic, strong) CXSessionTaskManager *sessionTaskManager;
@end


@implementation CXSession

+ (instancetype)sharedInstance {
    static CXSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[CXSession alloc] init];
    });
    return session;
}

- (void)send:(CXRequest *)request completion:(CXSessionCallback)completion {
    [self send:request callbackQueue:dispatch_get_main_queue() completion:completion];
}

- (void)send:(CXRequest *)request callbackQueue:(dispatch_queue_t)callbackQueue completion:(CXSessionCallback)completion {
    NSError *error = nil;
    NSURLRequest *urlRequest = [self create:request error:&error];
    if (error) {
        dispatch_async(callbackQueue, ^{
            if (completion) {
                completion(error, nil);
            }
        });
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    __weak __typeof(self)weakSelf = self;
    __block NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf handleTask:dataTask
                        data:data
                    response:response
                        error:error];
    }];
    
    CXSessionTask *sessionTask = [[CXSessionTask alloc] initWith:request sessionTask:dataTask];
    sessionTask.callbackQueue = callbackQueue;
    sessionTask.callback = completion;
    [self.sessionTaskManager add:sessionTask];
    
    [sessionTask resume];
}

- (void)handleTask:(NSURLSessionDataTask *)dataTask
              data:(NSData *)data
          response:(NSURLResponse *)response
             error:(NSError *)error
{
    CXSessionTask *sessionTask = [self.sessionTaskManager getTask:dataTask];
    if (!sessionTask) {
        return;
    }
    
    dispatch_async(sessionTask.callbackQueue, ^{
        if (!sessionTask.callback) {
            [self.sessionTaskManager remove:sessionTask];
            return;
        }
        
        if (error) {
            sessionTask.callback(error, nil);
        } else {
            NSObject <CXResponseAdapter> *responseAdapter = sessionTask.request.responseAdapter;
            if (responseAdapter) {
                NSError *adapterError = nil;
                NSDictionary *adaptedDictionary = [responseAdapter adapted:response withData:data withError:&adapterError];
                if (adapterError) {
                    NSString *originalResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"adapt response occur error, original response is: \n%@", originalResponse);
                    sessionTask.callback(adapterError, nil);
                } else {
                    sessionTask.callback(nil, adaptedDictionary);
                }
            } else {
                // no adapter, just convert data to json
                NSError *interError = nil;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&interError];
                sessionTask.callback(interError, result);
            }
        }
        [self.sessionTaskManager remove:sessionTask];
    });
}


- (NSURLRequest *)create:(CXRequest *)request error:(NSError **)error {
    NSURL *url = [NSURL URLWithString:request.urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:request.cachePolicy timeoutInterval:request.timeout];
    for (NSObject <CXRequestAdapter> *adaptor in request.requestAdapters) {
        [adaptor adapted:urlRequest withRequet:request withError:error];
        if (*error) {
            break;
        }
    }
    return urlRequest;
}

@end
