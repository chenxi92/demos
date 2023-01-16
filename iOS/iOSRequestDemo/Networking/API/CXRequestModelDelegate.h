//
//  CXRequestModelDelegate.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXRequestModelDelegate <NSObject>

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
