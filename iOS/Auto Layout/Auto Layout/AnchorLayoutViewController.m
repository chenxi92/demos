//
//  AnchorLayoutViewController.m
//  Auto Layout
//
//  Created by chenxi on 2020/6/8.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "AnchorLayoutViewController.h"

@interface AnchorLayoutViewController ()

@end

@implementation AnchorLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
 
    [self configUI];
}

- (void)configUI {
    UIView *yellow = [[UIView alloc] init];
    yellow.translatesAutoresizingMaskIntoConstraints = NO;
    yellow.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:yellow];
    
    UIView *green = [[UIView alloc] init];
    green.translatesAutoresizingMaskIntoConstraints = NO;
    green.backgroundColor = UIColor.greenColor;
    [yellow addSubview:green];
    
    UIView *red = [[UIView alloc] init];
    red.translatesAutoresizingMaskIntoConstraints = NO;
    red.backgroundColor = UIColor.redColor;
    [yellow addSubview:red];
    
    CGFloat margin = 20;
    [yellow.leadingAnchor  constraintEqualToAnchor:self.view.leadingAnchor constant:margin].active = YES;
    [yellow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-margin].active = YES;
    [yellow.topAnchor      constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [yellow.bottomAnchor   constraintEqualToAnchor:self.view.bottomAnchor constant:-margin].active = YES;
    
    [green.leadingAnchor   constraintEqualToAnchor:yellow.leadingAnchor constant:margin].active = YES;
    [green.trailingAnchor  constraintEqualToAnchor:yellow.trailingAnchor constant:-margin].active = YES;
    [green.topAnchor       constraintEqualToAnchor:yellow.topAnchor constant:margin].active = YES;
    [green.bottomAnchor    constraintEqualToAnchor:red.topAnchor constant:-margin].active = YES;
    
    [red.leadingAnchor     constraintEqualToAnchor:green.leadingAnchor].active = YES;
    [red.trailingAnchor    constraintEqualToAnchor:green.trailingAnchor].active = YES;
    [red.bottomAnchor      constraintEqualToAnchor:yellow.bottomAnchor constant:-margin].active = YES;
    [red.heightAnchor      constraintEqualToAnchor:green.heightAnchor multiplier:1.5].active = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
