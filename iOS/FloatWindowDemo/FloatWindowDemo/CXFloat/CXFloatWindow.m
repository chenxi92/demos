//
//  CXFloatWindow.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "CXFloatWindow.h"

@implementation CXFloatWindow

- (void)dealloc {
    NSLog(@"--- CXFloatWindow dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.windowLevel = UIWindowLevelStatusBar + 100;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_touchesDelegate window:self shouldReceiveTouchPoint:point]) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

@end
