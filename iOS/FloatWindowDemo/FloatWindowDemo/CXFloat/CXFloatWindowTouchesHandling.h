//
//  CXFloatWindowTouchesHandling.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXFloatWindowTouchesHandling <NSObject>

- (BOOL)window:(nullable UIWindow *)window shouldReceiveTouchPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
