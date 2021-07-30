//
//  ViewController.m
//  SocketServerTest
//
//  Created by chenxi on 2020/7/6.
//  Copyright © 2020 chenxi. All rights reserved.
//

#import "ViewController.h"
#import "CXServerSocket.h"

@interface ViewController ()<CXServerSocket>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CXServerSocket sharedIInstance].delegate = self;
}

- (IBAction)create:(id)sender {
    BOOL success = [[CXServerSocket sharedIInstance] creatSocket:@"127.0.0.1" withPort:8092];
    self.statusLabel.text = success ? @"creat socket success": @"creat socket fail";
}

- (IBAction)send:(id)sender {
    NSString *msg = self.inputTextField.text;
    if (msg.length < 1) {
        return;
    }
    
    [[CXServerSocket sharedIInstance] sendMessage:msg];
}

#pragma mark - CXServerSocket

- (void)socket:(CXServerSocket *)socket connectSuccess:(int)clientId {
    NSString *logMsg = [NSString stringWithFormat:@"client %d connect success.", clientId];
    [self showLogsWithString:logMsg];
}

- (void)socket:(CXServerSocket *)socket connectFail:(int)failCode {
    NSString *logMsg = [NSString stringWithFormat:@"client connect fail: %d.", failCode];
    [self showLogsWithString:logMsg];
}

- (void)socket:(CXServerSocket *)socket disConnect:(int)clientId {
    NSString *logMsg = [NSString stringWithFormat:@"client %d disconnect.", clientId];
    [self showLogsWithString:logMsg];
}

- (void)socket:(CXServerSocket *)socket didReceiveMessage:(NSString *)message withClient:(int)clientId {
    NSString *logMsg = [NSString stringWithFormat:@"client %d: %@.", clientId, message];
    [self showLogsWithString:logMsg];
}

    //在界面上显示日志
- (void)showLogsWithString:(NSString*)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--- %@", msg);
        self.logTextView.text = [self.logTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",msg]];
    });
}
@end
