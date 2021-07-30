//
//  ViewController.m
//  SocketClientTest
//
//  Created by chenxi on 2020/7/6.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "ViewController.h"
#import "CXSocket.h"

@interface ViewController ()<CXSocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextView;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CXSocket shareInstance].delegate = self;
}

- (IBAction)connect:(id)sender {
    
    BOOL success = [[CXSocket shareInstance] createSocket:@"127.0.0.1" withPort:@"8092"];
    
    self.statusLabel.text = success ? @"connect success": @"connect fail";
}

- (IBAction)send:(id)sender {
    NSString *msg = self.inputTextView.text;
    if (msg.length < 1) {
        return;
    }
    [[CXSocket shareInstance] sendMessage:msg];
}

- (void)socket:(CXSocket *)socket didReceiveMessage:(NSString *)message {
    NSString *previousMessage = self.logTextView.text;
    if (previousMessage) {
        self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", previousMessage, message];
    } else {
        self.logTextView.text = message;
    }
}
@end
