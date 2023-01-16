//
//  CXRequestJsonParameterEncryptAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "CXRequestJsonParameterAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// An adapter to encrypt parameter and convert to body data.
@interface CXRequestJsonParameterEncryptAdapter : CXRequestJsonParameterAdapter

@property (nonatomic, copy) NSDictionary * (^encryptBlock)(NSDictionary *parameter);

@end

NS_ASSUME_NONNULL_END
