//
//  Caculator.m
//  BlockChain
//
//  Created by 陈希 on 2020/6/14.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "Caculator.h"

@implementation Caculator

- (Caculator * _Nonnull (^)(CGFloat))addition {
    return ^Caculator *(CGFloat number) {
        self -> _result += number;
        return self;
    };
}

- (Caculator * _Nonnull (^)(CGFloat))substraction {
    return ^Caculator *(CGFloat number) {
        self -> _result -= number;
        return self;
    };
}

- (Caculator * _Nonnull (^)(CGFloat))multiplication {
    return ^Caculator *(CGFloat number) {
        self -> _result *= number;
        return self;
    };
}

- (Caculator * _Nonnull (^)(CGFloat))division {
    return ^Caculator *(CGFloat number) {
        self -> _result /= number;
        return self;
    };
}
@end
