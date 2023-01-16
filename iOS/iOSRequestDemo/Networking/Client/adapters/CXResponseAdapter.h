//
//  CXResponseAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Adapter to verify and parse response.
@protocol CXResponseAdapter <NSObject>

/// Modify the response.
/// @param response The original http response.
/// @param data The response data if any.
/// @param error The error info if any.
- (NSDictionary * _Nullable)adapted:(NSURLResponse * _Nullable)response
                           withData:(NSData * _Nullable)data
                          withError:(NSError ** _Nullable)error;

@end

NS_ASSUME_NONNULL_END
