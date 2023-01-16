//
//  CXResponseDecryptAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import "CXResponseValidAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// An adapter to decrypt response info.
@interface CXResponseDecryptAdapter : CXResponseValidAdapter

@property (nonatomic, copy) NSDictionary * (^decryptBlock)(NSDictionary *response);

@end

NS_ASSUME_NONNULL_END
