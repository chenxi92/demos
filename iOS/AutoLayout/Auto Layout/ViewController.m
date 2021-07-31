//
//  ViewController.m
//  Auto Layout
//
//  Created by chenxi on 2020/6/4.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "ViewController.h"
#import "AnchorLayoutViewController.h"

@interface ViewController ()
@end

@implementation ViewController

// view1.attribute1 = mutiplier * view2.attribute2 + constant

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI {
    UIView *superView = self.view;
    
    UIView *view1 = [[UIView alloc] init];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = [UIColor greenColor];
    [superView addSubview:view1];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, -20, -20);
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view1
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:padding.top];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view1
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:superView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:padding.left];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view1
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:padding.bottom];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:superView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:padding.right];
    [superView addConstraints:@[top, left, bottom, right]];
    
    // view2 is topleft in view1
    UIView *view2 = [[UIView alloc] init];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    view2.backgroundColor = [UIColor blueColor];
    [view1 addSubview:view2];
    
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:view2
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view1
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0 constant:20];
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:view2
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view1
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:20];
    NSLayoutConstraint *width2 = [NSLayoutConstraint constraintWithItem:view2
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:100];
    NSLayoutConstraint *height2 = [NSLayoutConstraint constraintWithItem:view2
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:100];
    [view1 addConstraints:@[top2, left2, width2, height2]];
    
    
    // view3 is horizontal with view2
    UIView *view3 = [[UIView alloc] init];
    view3.translatesAutoresizingMaskIntoConstraints = NO;
    view3.backgroundColor = [UIColor redColor];
    [view1 addSubview:view3];
    
    NSLayoutConstraint *right3 = [NSLayoutConstraint constraintWithItem:view3
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view1
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-20];
    NSLayoutConstraint *top3 = [NSLayoutConstraint constraintWithItem:view3
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view2
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:0];
    NSLayoutConstraint *width3 = [NSLayoutConstraint constraintWithItem:view3
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view2
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0];
    NSLayoutConstraint *heigh3 = [NSLayoutConstraint constraintWithItem:view3
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view2
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0];
    [view1 addConstraints:@[right3, top3, width3, heigh3]];
    
    
    // view4 is horizontal with view3
    UIView *view4 = [[UIView alloc] init];
    view4.translatesAutoresizingMaskIntoConstraints = NO;
    view4.backgroundColor = [UIColor purpleColor];
    [view1 addSubview:view4];
    
    NSLayoutConstraint *right4 = [NSLayoutConstraint constraintWithItem:view4
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view3
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:0];
    NSLayoutConstraint *top4 = [NSLayoutConstraint constraintWithItem:view4
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view3
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:30];
    NSLayoutConstraint *width4 = [NSLayoutConstraint constraintWithItem:view4
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view3
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0];
    NSLayoutConstraint *heigh4 = [NSLayoutConstraint constraintWithItem:view4
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view3
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0];
    [view1 addConstraints:@[right4, top4, width4, heigh4]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"Jump to Anchor Layout" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpToAnchorLayoutViewController) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];

    NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150];
    NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    NSLayoutConstraint *btnCenterX = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [view1 addConstraints:@[btnWidth, btnHeight, btnCenterX, btnCenterY]];
}


- (void)jumpToAnchorLayoutViewController {
    AnchorLayoutViewController *vc = [[AnchorLayoutViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    vc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}
@end
