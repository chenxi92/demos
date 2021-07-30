//
//  CXMovableViewController.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXMovableViewController <NSObject>

- (void)containerWillMove:(nonnull UIViewController *)container;

- (BOOL)shouldStretchInMoableContrainer;

- (CGFloat)minimumHeightInMovableContainer;

@end

NS_ASSUME_NONNULL_END
