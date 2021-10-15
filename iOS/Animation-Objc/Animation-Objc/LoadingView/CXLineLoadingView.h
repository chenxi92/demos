//
//  CXLineLoadingView.h
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXLineLoadingView : UIView

+ (void)showLoadingInView:(UIView *)view withHeight:(CGFloat)lineHeight;

+ (void)hideLoadingInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
