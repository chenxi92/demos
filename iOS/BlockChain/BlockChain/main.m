//
//  main.m
//  BlockChain
//
//  Created by 陈希 on 2020/6/14.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Caculator.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        CGFloat result = [NSObject caculate:^(Caculator * _Nonnull caculate) {
            caculate.addition(10).substraction(2).division(4).multiplication(3);
        }];
        
        NSLog(@"result : %.f", result);
    }
    return 0;
}
