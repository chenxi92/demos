//
//  CXFloat.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "CXFloat.h"
#import "CXFloatWindow.h"
#import "CXContainerViewController.h"
#import "CXfloatingButtonController.h"

@interface CXFloat ()<CXFloatWindowTouchesHandling>
@property (nonatomic, strong) CXFloatWindow *floatWindow;
@end

@implementation CXFloat
{
    CXContainerViewController *_containerViewController;
    CXfloatingButtonController *_floatingButtonController;
}

- (void)enable {
    _enabled = YES;
    _containerViewController = [CXContainerViewController new];
    
    _floatWindow = [[CXFloatWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _floatWindow.touchesDelegate = self;
    _floatWindow.rootViewController = _containerViewController;
    _floatWindow.hidden = NO;
    
    self.presentationMode = CXPresentationModeCondensed;
}

- (void)disable {
    self.presentationMode = CXPresentationModeDisable;
    _floatWindow = nil;
    _enabled = NO;
}

- (void)setPresentationMode:(CXPresentationMode)presentationMode {
    if (self.presentationMode != presentationMode) {
        switch (presentationMode) {
            case CXPresentationModeFullWindow:
                NSLog(@"-- full");
                return;
                break;
            case CXPresentationModeCondensed:
                [self showFloatingButton];
                break;
            case CXPresentationModeDisable:
                [self hidFloatingButton];
                break;
        }
    }
    
    _presentationMode = presentationMode;
}

#pragma mark - Floating button presentation

- (void)showFloatingButton {
    _floatingButtonController = [CXfloatingButtonController new];
    _floatingButtonController.presentationModeDelegate = self;
    
    [_containerViewController presentViewController:_floatingButtonController withSize:CGSizeMake(52, 52)];
}

- (void)hidFloatingButton {
    [_containerViewController dismissCurrentViewControlelr];
    _floatingButtonController = nil;
}


#pragma mark - CXPresentationModeDelegate

- (void)presentationDelegateChangezpresentationModeToMode:(CXPresentationMode)mode {
    self.presentationMode = mode;
}

#pragma mark - CXFloatWindowTouchesHandling

- (BOOL)window:(nullable UIWindow *)window shouldReceiveTouchPoint:(CGPoint)point {
    switch (_presentationMode) {
        case CXPresentationModeFullWindow:
//            return CGRectContainsPoint(_profilerViewController.view.bounds,
//            [_profilerViewController.view convertPoint:point
//                                              fromView:window]);
            return NO;
            break;
        case CXPresentationModeCondensed:
            return CGRectContainsPoint(_floatingButtonController.view.bounds,
                                            [_floatingButtonController.view convertPoint:point
                                                                                fromView:window]);
            break;
        case CXPresentationModeDisable:
            return NO;
    }
}

@end
