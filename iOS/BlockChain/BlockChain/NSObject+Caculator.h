//
//  NSObject+Caculator.h
//  BlockChain
//
//  Created by 陈希 on 2020/6/14.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Caculator.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Caculator)

- (CGFloat)caculate:(void (^)(Caculator *caculate))block;

@end

NS_ASSUME_NONNULL_END
