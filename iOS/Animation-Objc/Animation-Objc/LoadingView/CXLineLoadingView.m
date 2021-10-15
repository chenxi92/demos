//
//  CXLineLoadingView.m
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import "CXLineLoadingView.h"
#import <QuartzCore/QuartzCore.h>

#define LoadingDuration 0.75

@implementation CXLineLoadingView

+ (void)showLoadingInView:(UIView *)view withHeight:(CGFloat)lineHeight {
    CXLineLoadingView *loadingView = [[CXLineLoadingView alloc] initWithFrame:view.frame lineHeight:lineHeight];
    [view addSubview:loadingView];
    [loadingView startLoading];
}

+ (void)hideLoadingInView:(UIView *)view {
    NSEnumerator *enumerator = [view.subviews reverseObjectEnumerator];
    for (UIView *view in enumerator) {
        if ([view isKindOfClass:[CXLineLoadingView class]] == NO) {
            continue;
        }
        CXLineLoadingView *loadingView = (CXLineLoadingView *)view;
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame lineHeight:(CGFloat)lineHeight {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        self.bounds = CGRectMake(0, 0, 1.0f, lineHeight);
    }
    return self;
}

- (void)startLoading {
    [self stopLoading];
    
    self.hidden = NO;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = LoadingDuration;
    animationGroup.beginTime = CACurrentMediaTime();
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale.x";
    scaleAnimation.fromValue = @(1.0f);
    scaleAnimation.toValue = @(1.0f * self.superview.frame.size.width);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.5f);
    
    animationGroup.animations = @[scaleAnimation, alphaAnimation];
    [self.layer addAnimation:animationGroup forKey:nil];
}

- (void)stopLoading {
    [self.layer removeAllAnimations];
    self.hidden = YES;
}

@end
