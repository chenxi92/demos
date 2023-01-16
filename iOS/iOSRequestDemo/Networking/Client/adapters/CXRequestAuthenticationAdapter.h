//
//  CXRequestAuthenticationAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "CXRequestAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// An adapter to manipulate `Authorization` field in http header.
@interface CXRequestAuthenticationAdapter : NSObject <CXRequestAdapter>

/// Create a adapter.
/// @param token The token to add.
///
/// @discussion If the token is nil or empty string, will remove `Authorization` field in http header.
- (instancetype)initWithToken:(NSString * _Nullable)token;

@end

NS_ASSUME_NONNULL_END
