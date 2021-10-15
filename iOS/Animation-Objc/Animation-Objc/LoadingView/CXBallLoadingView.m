//
//  CXBallLoadingView.m
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import "CXBallLoadingView.h"

#define kBallWidth     12.0f
#define kBallSpeed     0.7f
#define kBallZoomScale 0.25
#define kBallPauseTime 0.18

typedef NS_ENUM(NSUInteger, CXBallMoveDirection) {
    CXBallMoveDirectionPositive = 1,
    CXBallMoveDirectionNegative = -1
};

@interface CXBallLoadingView()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *greenBall;

@property (nonatomic, strong) UIView *redBall;

@property (nonatomic, strong) UIView *blackBall;

@property (nonatomic, assign) CXBallMoveDirection moveDirection;

@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation CXBallLoadingView

# pragma mark - Public

+ (instancetype)loadingViewInView:(UIView *)view {
    CXBallLoadingView *loadingView = [[CXBallLoadingView alloc] initWithFrame:view.bounds];
    [view addSubview:loadingView];
    return loadingView;
}

- (void)startLoading {
    [self startAnimation];
}

- (void)stopLoading {
    [self stopAnimation];
}

# pragma mark - Private

- (void)startAnimation {
    [self pauseAnimation];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateBallAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)pauseAnimation {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)stopAnimation {
    [self pauseAnimation];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:nil];
    
    [self.greenBall addSubview:self.blackBall];
    [self.containerView bringSubviewToFront:self.greenBall];
    self.moveDirection = CXBallMoveDirectionPositive;
    [self updateBallPositionWithProgress:0];
}

- (void)resetAnimation {
    [self pauseAnimation];
    
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:kBallPauseTime];
}

- (void)updateBallPositionWithProgress:(CGFloat)progress {
//    CGPoint center = self.greenBall.center;
//    center.x = kBallWidth * 0.5 + 1.1 * kBallWidth * progress;
//    self.greenBall.center = center;
//
//    center = self.redBall.center;
//    center.x = kBallWidth * 2.6 - 1.1 * kBallWidth * progress;
//    self.redBall.center = center;
//
//    if (progress != 0 && progress != 1) {
//        self.greenBall.transform = [self ballLargerTransformOfCenterX:center.x];
//        self.redBall.transform = [self ballSmallerTransformOfCenterX:center.x];
//    } else {
//        self.greenBall.transform = CGAffineTransformIdentity;
//        self.redBall.transform = CGAffineTransformIdentity;
//    }
//
//    [self updateBlackBall];
}

- (void)updateBallAnimation {
    if (self.moveDirection == CXBallMoveDirectionPositive) {
        [self movePositive];
    } else if (self.moveDirection == CXBallMoveDirectionNegative) {
        [self moveNegative];
    } else {
        
    }
}

- (void)updateBlackBall {
    CGRect blackBallFrame = [self.redBall convertRect:self.redBall.bounds toCoordinateSpace:self.greenBall];
    self.blackBall.frame = blackBallFrame;
    self.blackBall.layer.cornerRadius = self.blackBall.bounds.size.width * 0.5;
}

- (void)movePositive {
    // 更新绿球位置
    CGPoint center = self.greenBall.center;
    center.x += kBallSpeed;
    self.greenBall.center = center;
    
    // 更新红球位置
    center = self.redBall.center;
    center.x -= kBallSpeed;
    self.redBall.center = center;
    
    // 缩放动画，绿球放大，红球缩小
    self.greenBall.transform = [self ballLargerTransformOfCenterX:center.x];
    self.redBall.transform   = [self ballSmallerTransformOfCenterX:center.x];
    
    // 更新黑球位置
    [self updateBlackBall];
    
    // 更新方向 改变三个球的相对位置
    if (CGRectGetMaxX(self.greenBall.frame) >= self.containerView.bounds.size.width || CGRectGetMinX(self.redBall.frame) <= 0) {
        // 切换为反向
        self.moveDirection = CXBallMoveDirectionNegative;
        
        // 反向运动时，红球在上，绿球在下
        [self.containerView bringSubviewToFront:self.redBall];
        
        // 黑球放在红球上面
        [self.redBall addSubview:self.blackBall];
        
        // 重置动画
        [self resetAnimation];
    }
}

- (void)moveNegative {
    // 更新绿球位置
    CGPoint center = self.greenBall.center;
    center.x -= kBallSpeed;
    self.greenBall.center = center;
    
    // 更新红球位置
    center = self.redBall.center;
    center.x += kBallSpeed;
    self.redBall.center = center;
    
    // 缩放动画 红球放大 绿球缩小
    self.redBall.transform = [self ballLargerTransformOfCenterX:center.x];
    self.greenBall.transform = [self ballSmallerTransformOfCenterX:center.x];
    
    // 更新黑球位置
    [self updateBlackBall];
    
    // 更新方向 改变三个球的相对位置
    if (CGRectGetMinX(self.greenBall.frame) <= 0 || CGRectGetMaxX(self.redBall.frame) >= self.containerView.bounds.size.width) {
        // 切换为正向
        self.moveDirection = CXBallMoveDirectionPositive;
        
        // 正向运动 绿球在上 红球在下
        [self.containerView bringSubviewToFront:self.greenBall];
        
        // 黑球放在绿球上面
        [self.greenBall addSubview:self.blackBall];
        
        // 重置动画
        [self resetAnimation];
    }
}

/// 放大动画
- (CGAffineTransform)ballLargerTransformOfCenterX:(CGFloat)centerX {
    CGFloat cosValue = [self cosValueOfCenterX:centerX];
    return CGAffineTransformMakeScale(1 + cosValue * kBallZoomScale, 1 + cosValue * kBallZoomScale);
}

- (CGAffineTransform)ballSmallerTransformOfCenterX:(CGFloat)centerX {
    CGFloat cosValue = [self cosValueOfCenterX:centerX];
    return CGAffineTransformMakeScale(1 - cosValue * kBallZoomScale, 1 - cosValue * kBallZoomScale);
}

- (CGFloat)cosValueOfCenterX:(CGFloat)centerX {
    CGFloat apart = centerX - self.containerView.bounds.size.width * 0.5;
    CGFloat maxApart = (self.containerView.bounds.size.width - kBallWidth * 0.5);
    CGFloat angle = apart / (maxApart * M_PI_2);
    return cos(angle);
}

# pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.greenBall];
    [self.containerView addSubview:self.redBall];
    [self.greenBall addSubview:self.blackBall];

    self.moveDirection = CXBallMoveDirectionPositive;
    [self.containerView bringSubviewToFront:self.greenBall];

    [self updateBallPositionWithProgress:0];
}


- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.center = self.center;
        _containerView.bounds = CGRectMake(0, 0, 3.0f * kBallWidth, 2.0f * kBallWidth);
//        _containerView.backgroundColor = [UIColor yellowColor];
    }
    return _containerView;
}

- (UIView *)buildBall {
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBallWidth, kBallWidth)];
    ball.layer.cornerRadius = kBallWidth * 0.5;
    ball.layer.masksToBounds = YES;
    return ball;
}

- (UIView *)greenBall {
    if (!_greenBall) {
        _greenBall = [self buildBall];
        _greenBall.center = CGPointMake(kBallWidth * 0.5f, self.containerView.bounds.size.height * 0.5);
        _greenBall.backgroundColor = [UIColor colorWithRed:35/255.0 green:246/255.0 blue:235/255.0 alpha:1];
    }
    return _greenBall;
}

- (UIView *)redBall {
    if (!_redBall) {
        _redBall = [self buildBall];
        _redBall.center = CGPointMake(self.containerView.bounds.size.width - kBallWidth * 0.5f, self.containerView.bounds.size.height * 0.5);
        _redBall.backgroundColor = [UIColor colorWithRed:255/255.0 green:46/255.0 blue:86/255.0 alpha:1];
    }
    return _redBall;
}

- (UIView *)blackBall {
    if (!_blackBall) {
        _blackBall = [self buildBall];
        _blackBall.backgroundColor = [UIColor colorWithRed:12/255.0 green:11/255.0 blue:17/255.0 alpha:1];
    }
    return _blackBall;
}
@end
