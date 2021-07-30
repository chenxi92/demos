//
//  CXFloatWindow.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXFloatWindowTouchesHandling.h"
NS_ASSUME_NONNULL_BEGIN

@interface CXFloatWindow : UIWindow

@property (nonatomic, weak, nullable) id<CXFloatWindowTouchesHandling>touchesDelegate;

@end

NS_ASSUME_NONNULL_END
