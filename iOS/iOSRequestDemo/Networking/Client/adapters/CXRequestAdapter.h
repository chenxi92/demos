//
//  CXRequestAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CXRequest;

///  Adapters modify the mutable `NSMutableURLRequest` object.
@protocol CXRequestAdapter <NSObject>

/// Adapt a mutable URLRequest object.
/// @param urlRequest The `URLRequest` to be adapted.
/// @param request The request object.
/// @param error The error info if any.
- (void)adapted:(NSMutableURLRequest *)urlRequest withRequet:(CXRequest *)request withError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
