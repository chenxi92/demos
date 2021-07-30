//
//  Caculator.h
//  BlockChain
//
//  Created by 陈希 on 2020/6/14.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Caculator : NSObject

@property (nonatomic, assign, readonly) CGFloat result;

- (Caculator * (^) (CGFloat number))addition;

- (Caculator * (^) (CGFloat number))substraction;

- (Caculator * (^) (CGFloat number))multiplication;

- (Caculator * (^) (CGFloat number))division;


@end

NS_ASSUME_NONNULL_END
