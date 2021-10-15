//
//  CXDoubleLikeView.m
//  Animation-Objc
//
//  Created by peak on 2021/9/9.
//

#import "CXDoubleLikeView.h"

@implementation CXDoubleLikeView

- (void)createAnimationWithTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount <= 1.0f) {
        return;
    }
    
    CGPoint point = [touch locationInView:touch.view];
    UIImage *image = [UIImage imageNamed:@"likeHeart"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.center = point;
    
    int leftOrRight = arc4random() % 2;
    leftOrRight = leftOrRight ?: -1;
    imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI / 9.0f * leftOrRight);
    [touch.view addSubview:imageView];
    
    __block UIImageView *blockImageView = imageView;
    __block UIImage *blockImage = image;
    
    [UIView animateWithDuration:0.1 animations:^{
        blockImageView.transform = CGAffineTransformScale(blockImageView.transform, 1.2f, 1.2f);
    } completion:^(BOOL finished) {
        blockImageView.transform = CGAffineTransformScale(blockImageView.transform, 0.8f, 0.8f);
        [self performSelector:@selector(animationToTop:) withObject:@[blockImageView, blockImage] afterDelay:0.3f];
    }];
}

- (void)animationToTop:(NSArray *)imageObjects {
    if (imageObjects && imageObjects.count > 1) {
        __block UIImageView *imageView = (UIImageView *)imageObjects[0];
        __block UIImage *image = (UIImage *)imageObjects[1];
        [UIView animateWithDuration:1.0f animations:^{
            CGRect imageViewFrame = imageView.frame;
            imageViewFrame.origin.y -= 100.0f;
            imageView.frame = imageViewFrame;
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.8f, 1.8f);
            imageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            imageView = nil;
            image = nil;
        }];
    }
}
@end
