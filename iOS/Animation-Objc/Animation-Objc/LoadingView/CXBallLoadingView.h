//
//  CXBallLoadingView.h
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXBallLoadingView : UIView

+ (instancetype)loadingViewInView:(UIView *)view;

- (void)startLoading;

- (void)stopLoading;
@end

NS_ASSUME_NONNULL_END
