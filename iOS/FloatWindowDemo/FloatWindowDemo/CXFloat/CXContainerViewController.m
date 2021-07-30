//
//  CXContainerViewController.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "CXContainerViewController.h"
#import "CXMovableViewController.h"

static UIEdgeInsets CXSafeAreaInsets(UIView *view) {
    if(@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

CGFloat CXRoundPixelValue(CGFloat value) {
  CGFloat scale = [[UIScreen mainScreen] scale];
  return roundf(value * scale) / scale;
}

@implementation CXContainerViewController
{
    UIViewController<CXMovableViewController> *_presentedViewController;
    UIPanGestureRecognizer   *_panGestureRecognizer;
//    UIPinchGestureRecognizer *_pinGestureRecognizer;
//    CGFloat _heightOnPinch;
//    CGFloat _previousPinchingPoint;
    
    CGSize _size;
    CGFloat _windowTop;
    CGFloat _windowBottom;
}

- (void)dealloc {
    NSLog(@"--- CXContainerViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)presentViewController:(UIViewController<CXMovableViewController> *)viewController withSize:(CGSize)size
{
    if (_presentedViewController) {
        [self dismissCurrentViewControlelr];
    }
    
    _presentedViewController = viewController;
    _size = size;
    CGSize adjustedSize = CGSizeMake(MIN(_size.width, CGRectGetWidth(self.view.bounds)),
                                     MIN(_size.height, CGRectGetHeight(self.view.bounds)));

    // Put content right under status bar, in the middle
    _windowTop = MAX(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), CXSafeAreaInsets(self.view).top);
    _windowBottom = CGRectGetHeight(self.view.bounds) - CXSafeAreaInsets(self.view).bottom;
    CGFloat widthOffset = CXRoundPixelValue((CGRectGetWidth(self.view.bounds) - adjustedSize.width) / 2.0);
    
    CGRect frame = CGRectMake(widthOffset, _windowTop, adjustedSize.width, adjustedSize.height);
    
    [self addChildViewController:_presentedViewController];
    _presentedViewController.view.frame = frame;
    [self.view addSubview:_presentedViewController.view];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [_presentedViewController.view addGestureRecognizer:_panGestureRecognizer];
    
    [_presentedViewController didMoveToParentViewController:self];
    
    if ([_presentedViewController shouldStretchInMoableContrainer]) {
        
    }
}

- (void)dismissCurrentViewControlelr {
    if (!_presentedViewController) {
        return;
    }
    
    [_presentedViewController willMoveToParentViewController:nil];
    
    [_panGestureRecognizer removeTarget:self action:NULL];
    _panGestureRecognizer = nil;
    
    [_presentedViewController.view removeFromSuperview];
    [_presentedViewController removeFromParentViewController];
}

- (void)pan {
    if (_panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
      [_presentedViewController containerWillMove:self];
    }
    
    CGPoint translation = [_panGestureRecognizer translationInView:self.view];
    CGPoint center = _presentedViewController.view.center;
    center.x += translation.x;
    center.y += translation.y;
    
    CGFloat centerHeightOffset = CXRoundPixelValue(CGRectGetHeight(_presentedViewController.view.frame) * 0.5);
    CGFloat centerWidthOffset = CXRoundPixelValue(CGRectGetWidth(_presentedViewController.view.frame) * 0.5);
    
    // Make sure it stays on screen
    if (center.y - centerHeightOffset < _windowTop) {
        center.y = _windowTop + centerHeightOffset;
    }
    if (center.x - centerWidthOffset < CXSafeAreaInsets(self.view).left) {
        center.x = centerWidthOffset + CXSafeAreaInsets(self.view).left;
    }
    
    CGFloat maximumY = _windowBottom -  CGRectGetHeight(_presentedViewController.view.frame);
    if (center.y - centerHeightOffset > maximumY) {
      center.y = maximumY + centerHeightOffset;
    }

    CGFloat maximumX = CGRectGetWidth(self.view.bounds) - CXSafeAreaInsets(self.view).right - CGRectGetWidth(_presentedViewController.view.frame);
    if (center.x - centerWidthOffset > maximumX) {
      center.x = maximumX + centerWidthOffset;
    }

    _presentedViewController.view.center = center;

    [_panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}


#pragma mark Rotations

- (UIViewController *)_viewControllerDecidingAboutRotations
{
#if _INTERNAL_IMP_ENABLED
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIViewController *viewController = window.rootViewController;
  SEL viewControllerForSupportedInterfaceOrientationsSelector =
  NSSelectorFromString(@"_viewControllerForSupportedInterfaceOrientations");
  if ([viewController respondsToSelector:viewControllerForSupportedInterfaceOrientationsSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    viewController = [viewController performSelector:viewControllerForSupportedInterfaceOrientationsSelector];
#pragma clang diagnostic pop
  }
  return viewController;
#else
  return self;
#endif // _INTERNAL_IMP_ENABLED
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  UIViewController *viewControllerToAsk = [self _viewControllerDecidingAboutRotations];
  UIInterfaceOrientationMask supportedOrientations = UIInterfaceOrientationMaskAll;
  if (viewControllerToAsk && viewControllerToAsk != self) {
    supportedOrientations = [viewControllerToAsk supportedInterfaceOrientations];
  }

  return supportedOrientations;
}

- (BOOL)shouldAutorotate
{
  UIViewController *viewControllerToAsk = [self _viewControllerDecidingAboutRotations];
  BOOL shouldAutorotate = YES;
  if (viewControllerToAsk && viewControllerToAsk != self) {
    shouldAutorotate = [viewControllerToAsk shouldAutorotate];
  }
  return shouldAutorotate;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // We did rotate, we should update frame of contained window (it was depending on bounds)
    CGSize adjustedSize = CGSizeMake(MIN(_size.width, CGRectGetWidth(self.view.bounds)),
                                     MIN(_size.height, CGRectGetHeight(self.view.bounds)));

    CGFloat widthOffset = MIN(_presentedViewController.view.frame.origin.x,
                              CGRectGetWidth(self.view.bounds) - adjustedSize.width);
    CGFloat heightOffset = MIN(_presentedViewController.view.frame.origin.y,
                               CGRectGetHeight(self.view.bounds) - adjustedSize.height);

    CGRect frame = CGRectMake(widthOffset, heightOffset, adjustedSize.width, adjustedSize.height);

    [UIView animateWithDuration:0.3 animations:^{
      self->_presentedViewController.view.frame = frame;
    }];
}

@end
