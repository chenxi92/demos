//
//  CXLikeView.m
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import "CXLikeView.h"

#define RGBColor(a, b, c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]

@interface CXLikeView()
@property (nonatomic, strong) UIImageView *likeBeforeImageView;
@property (nonatomic, strong) UIImageView *likeAfterImageView;
@end

@implementation CXLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.likeBeforeImageView];
        [self addSubview:self.likeAfterImageView];
        
        CGFloat imageWH = [UIImage imageNamed:@"icon_home_like_before"].size.width;
        self.likeBeforeImageView.frame = CGRectMake(0, 0, imageWH, imageWH);
        self.likeAfterImageView.frame = CGRectMake(0, 0, imageWH, imageWH);
        
        self.likeAfterImageView.hidden = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)setLike:(BOOL)like {
    _like = like;
    self.likeAfterImageView.hidden = !_like;
}

- (void)startAnimation:(BOOL)like {
    if (like == self.like) {
        return;
    }
    self.like = like;
    if (self.like) {
        [self likeAnimation];
    } else {
        [self dislikeAnimation];
    }
}

- (void)likeAnimation {
    CGFloat length = 30;
    CGFloat duration = 0.5f;
    for (NSInteger i = 0; i < 6; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.position = self.likeBeforeImageView.center;
        layer.fillColor = RGBColor(232, 50, 85).CGColor;
        
        /// 三角形
        UIBezierPath *startPath = [UIBezierPath bezierPath];
        [startPath moveToPoint:CGPointMake(-2, -length)];
        [startPath addLineToPoint:CGPointMake(2, -length)];
        [startPath addLineToPoint:CGPointMake(0, 0)];
        layer.path = startPath.CGPath;
        
        /// 旋转方向
        layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0, 0, 1.0);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.duration = duration;
        
        /// 缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(0.0f);
        scaleAnimation.toValue = @(1.0f);
        scaleAnimation.duration = duration * 0.2f;
        
        UIBezierPath *endPath = [UIBezierPath bezierPath];
        [endPath moveToPoint:CGPointMake(-2, -length)];
        [endPath addLineToPoint:CGPointMake(2, -length)];
        [endPath addLineToPoint:CGPointMake(0, -length)];
        
        /// 移动路径
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (__bridge id)layer.path;
        pathAnimation.toValue = (__bridge id)endPath.CGPath;
        pathAnimation.beginTime = duration * 0.2f;
        pathAnimation.duration = duration * 0.8f;
        
        animationGroup.animations = @[scaleAnimation, pathAnimation];
        [layer addAnimation:animationGroup forKey:nil];
        
        [self.layer addSublayer:layer];
    }
    
    self.likeAfterImageView.hidden = NO;
    self.likeAfterImageView.alpha = 0.0f;
    self.likeAfterImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.15 animations:^{
        self.likeAfterImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.likeAfterImageView.alpha = 1.0f;
        self.likeBeforeImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.likeAfterImageView.transform = CGAffineTransformIdentity;
        self.likeBeforeImageView.alpha = 1.0f;
    }];
}

- (void)dislikeAnimation {
    self.likeAfterImageView.alpha = 1.0f;
    self.likeAfterImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView animateWithDuration:0.15 animations:^{
        self.likeAfterImageView.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
    } completion:^(BOOL finished) {
        self.likeAfterImageView.transform = CGAffineTransformIdentity;
        self.likeAfterImageView.hidden = YES;
    }];
}

#pragma mark - Private

- (void)tapAction:(UIGestureRecognizer *)tap {
    [self startAnimation:!self.like];
}

#pragma mark - Lazy Load
- (UIImageView *)likeBeforeImageView {
    if (!_likeBeforeImageView) {
        _likeBeforeImageView = [[UIImageView alloc] init];
        _likeBeforeImageView.image = [UIImage imageNamed:@"icon_home_like_before"];
    }
    return _likeBeforeImageView;
}

- (UIImageView *)likeAfterImageView {
    if (!_likeAfterImageView) {
        _likeAfterImageView = [[UIImageView alloc] init];
        _likeAfterImageView.image = [UIImage imageNamed:@"icon_home_like_after"];
    }
    return _likeAfterImageView;
}
@end
