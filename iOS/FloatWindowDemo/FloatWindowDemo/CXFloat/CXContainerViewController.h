//
//  CXContainerViewController.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXMovableViewController;

NS_ASSUME_NONNULL_BEGIN

@interface CXContainerViewController : UIViewController

- (void)presentViewController:(nonnull UIViewController<CXMovableViewController> *)viewController withSize:(CGSize)size;

- (void)dismissCurrentViewControlelr;

@end

NS_ASSUME_NONNULL_END
