//
//  CXSession.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "CXRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CXSessionCallback)(NSError * _Nullable error, NSDictionary * _Nullable response);

/// A wrapper class about NSURLSession.
@interface CXSession : NSObject

+ (instancetype)sharedInstance;

/// Send a HTTP Request.
/// @param request The request object.
/// @param completion The completion handler invoked when finished request or occur error.
///
/// @discussion The completion will invoke on main queue by default.
- (void)send:(CXRequest *)request completion:(CXSessionCallback)completion;

/// Send a HTTP Request.
/// @param request The request object.
/// @param callbackQueue The specific queue to invoke the completion handler.
/// @param completion The completion handler invoked when finished request or occur error.
- (void)send:(CXRequest *)request callbackQueue:(dispatch_queue_t)callbackQueue completion:(CXSessionCallback)completion;

@end

NS_ASSUME_NONNULL_END
