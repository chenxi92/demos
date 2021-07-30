//
//  FBProjectViewController.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "FBProjectViewController.h"
#import <WebKit/WebKit.h>

@interface FBProjectViewController ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;
@end

@implementation FBProjectViewController


- (instancetype)initWithName:(NSString *)name URL:(NSURL *)url {
    if (self = [super init]) {
        self.title = name;
        
        _url = url;
    }
    return self;
}

- (void)loadView {
    _webView = [[WKWebView alloc] init];
    self.view = _webView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest *reqeust = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:reqeust];
}

@end
