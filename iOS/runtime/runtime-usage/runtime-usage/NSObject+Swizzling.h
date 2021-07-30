//
//  NSObject+Swizzling.h
//  usage
//
//  Created by 陈希 on 2020/4/18.
//  Copyright © 2020 chenxi. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)
@property (nonatomic, strong) id associatedObject;
@end

NS_ASSUME_NONNULL_END
