//
//  CXResponseModelDelegate.h
//  Networking
//
//  Created by peak on 2023/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXResponseModelDelegate <NSObject>

+ (instancetype)parse:(NSDictionary *)response;

@end

NS_ASSUME_NONNULL_END
