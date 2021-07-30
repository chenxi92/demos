//
//  ViewController.m
//  FloatWindowDemo
//
//  Created by peak on 2020/9/21.
//  Copyright © 2020 peak. All rights reserved.
//

#import "ViewController.h"
#import "FBProjectViewController.h"
#import "GithubRepository.h"

#import "CXFloat.h"

static NSString *const kReusableIdentifier = @"kReusableIdentifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <GithubRepository *>*data;
@property (nonatomic, strong) CXFloat *myFloat;
@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        _data = [NSArray array];
        self.title = @"Facebook Open Source";
    }
    return self;
}

- (void)loadView {
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.view = _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/orgs/facebook/repos?per_page=300"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration]];
    __weak __typeof(self)weakSelf = self;
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf paraseData:json];
                [weakSelf.tableView reloadData];
            });
        }
    }];
    [task resume];
    
    if (!_myFloat) {
        _myFloat = [[CXFloat alloc] init];
    }
    
    [_myFloat enable];
}

- (void)paraseData:(NSArray *)data {
    NSMutableArray<GithubRepository *> *parsedData = [NSMutableArray array];
    for (NSDictionary *repository in data) {
      GithubRepository *githubRepository =
      [[GithubRepository alloc] initWithName:repository[@"name"]
                            shortDescription:repository[@"description"]
                                         url:[NSURL URLWithString:repository[@"html_url"]]];
      [parsedData addObject:githubRepository];
    }
    
    _data = [parsedData copy];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCISupportedDecoderVersionsKey];
    }
    
    cell.textLabel.text = _data[indexPath.row].name;
    cell.detailTextLabel.text = _data[indexPath.row].shortDescription;
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GithubRepository *info = _data[indexPath.row];
    FBProjectViewController *vc = [[FBProjectViewController alloc] initWithName:info.name URL:info.url];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
