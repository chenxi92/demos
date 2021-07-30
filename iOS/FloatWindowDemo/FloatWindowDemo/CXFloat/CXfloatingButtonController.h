//
//  CXFloatingButtonViewController.h
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXMovableViewController.h"
#import "CXPresentationModeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXfloatingButtonController : UIViewController <CXMovableViewController>

@property (nonatomic, weak, nullable) id<CXPresentationModeDelegate> presentationModeDelegate;

@end

NS_ASSUME_NONNULL_END
