//
//  ViewController.m
//  Animation-Objc
//
//  Created by peak on 2021/9/8.
//

#import "ViewController.h"
#import "CXLineLoadingView.h"
#import "CXBallLoadingView.h"
#import "CXLikeView.h"
#import "CXDoubleLikeView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic, strong) CXBallLoadingView *ballView;
@property (nonatomic, assign) BOOL ballLoading;

@property (nonatomic, strong) CXLikeView *likeView;
@property (nonatomic, assign) BOOL likeLoading;

@property (nonatomic, strong) CXDoubleLikeView *doubleLikeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = 40;
    CGFloat height = width;
    CGFloat x = self.showView.bounds.size.width * 0.5 - width * 0.5;
    _likeView = [[CXLikeView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    [self.showView addSubview:_likeView];
    
}

- (IBAction)lineLoading:(id)sender {
    
    [CXLineLoadingView showLoadingInView:self.showView withHeight:3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CXLineLoadingView hideLoadingInView:self.showView];
    });
}

- (IBAction)ballLoading:(id)sender {
    if (!_ballView) {
        _ballView = [CXBallLoadingView loadingViewInView:self.showView];
    }
    
    self.ballLoading = !self.ballLoading;
    
    if (self.ballLoading) {
        [_ballView startLoading];
    } else {
        [_ballView stopLoading];
        [_ballView removeFromSuperview];
        _ballView = nil;
    }
}

- (IBAction)likeLoading:(id)sender {
    self.likeLoading = !self.likeLoading;
    if (self.likeLoading) {
        [_likeView startAnimation:YES];
    } else {
        [_likeView startAnimation:NO];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.doubleLikeView createAnimationWithTouch:touches withEvent:event];
}

- (CXDoubleLikeView *)doubleLikeView {
    if (!_doubleLikeView) {
        _doubleLikeView = [[CXDoubleLikeView alloc] init];
    }
    return _doubleLikeView;
}
@end
