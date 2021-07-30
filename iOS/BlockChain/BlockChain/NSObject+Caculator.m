//
//  NSObject+Caculator.m
//  BlockChain
//
//  Created by 陈希 on 2020/6/14.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "NSObject+Caculator.h"

@implementation NSObject (Caculator)

- (CGFloat)caculate:(void (^)(Caculator * _Nonnull))block {
    Caculator *caculate = [[Caculator alloc] init];
    block(caculate);
    return caculate.result;
}
@end
