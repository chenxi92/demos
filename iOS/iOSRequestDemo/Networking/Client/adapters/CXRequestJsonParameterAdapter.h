//
//  CXRequestJsonParameterAdapter.h
//  CXNetworking
//
//  Created by peak on 2023/1/13.
//

#import <Foundation/Foundation.h>
#import "CXRequestAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// An adapter to convert paramter to body data.
@interface CXRequestJsonParameterAdapter : NSObject <CXRequestAdapter>

- (NSData *)dictionaryToData:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
