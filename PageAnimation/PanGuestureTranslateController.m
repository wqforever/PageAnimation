//
//  PanGuestureTranslateController.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/9/7.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "PanGuestureTranslateController.h"
#import "PageAnimation.h"
#import <CoreGraphics/CoreGraphics.h>

@interface PanGuestureTranslateController ()
@property (nonatomic, strong) UILabel *toView;
/** <#描述#> */
@property (nonatomic, strong) UIImageView *removeImageView;
/** <#描述#> */
@property (nonatomic, strong) UIImage *tLeftImage;
/** <#描述#> */
@property (nonatomic, strong) UIImage *tRightImage;
/** <#描述#> */
@property (nonatomic, strong) UIImage *fLeftImage;
/** <#描述#> */
@property (nonatomic, strong) UIImage *fRightImage;
/** <#描述#> */
@property (nonatomic, assign) double angel;
@end

@implementation PanGuestureTranslateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (UILabel *)toView {
    if (!_toView) {
        _toView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
        _toView.backgroundColor = [UIColor blueColor];
        _toView.text = @"123";
        _toView.textColor = [UIColor blackColor];
        _toView.font = [UIFont systemFontOfSize:20];
        _toView.textAlignment = NSTextAlignmentCenter;
    }
    return _toView;
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *fromView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    fromView.userInteractionEnabled = YES;
    fromView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:fromView];
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH / 2, MAINHEIGHT)];
//    imageView.image = [self screenShotImageFromView:self.toView cutSize:CGSizeMake(self.toView.frame.size.width / 2, self.toView.frame.size.height)];
//    [self.view addSubview:imageView];
    
    //[[[PageAnimation alloc]init]addPanGuestureFromView:fromView toView:self.toView];
    
    [self addPanGuestureFromView:fromView toView:self.toView];
}
//手滑动翻页
- (UIImage *)screenShotImageFromViewLayer:(UIView *)view cutSize:(CGRect )rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    
    [view.layer renderInContext:context];
    
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)screenShotImageFromView:(UIView *)view cutSize:(CGRect )rect {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width / 2, rect.size.height), NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    
    [view.layer renderInContext:context];
    //[view drawViewHierarchyInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) afterScreenUpdates:NO];

    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)addPanGuestureFromView:(UIView *)fView toView:(UIView *)tView {
    
    CGRect fFrame = fView.frame;
    CGRect tFrame = tView.frame;
    
    self.fLeftImage = [self screenShotImageFromViewLayer:fView cutSize:CGRectMake(0, 0, fFrame.size.width / 2, fFrame.size.height)];
    self.fRightImage = [self screenShotImageFromViewLayer:fView cutSize:CGRectMake(-fFrame.size.width / 2, 0, fFrame.size.width / 2, fFrame.size.height)];
    //翻转图
    tView.frame = CGRectMake(0, 0, tFrame.size.width, tFrame.size.height);
    tView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
    UIView *tBackView = [[UIView alloc]initWithFrame:tFrame];
    tBackView.backgroundColor = [UIColor redColor];
    //[self.view addSubview:tBackView];
    [tBackView addSubview:tView];
    
    self.tLeftImage = [self screenShotImageFromView:tView cutSize:CGRectMake(0, 0, tFrame.size.width, tFrame.size.height)];
    //tView.layer.transform = CATransform3DIdentity;
    NSLog(@"tleftimage:%@",_tLeftImage);
    self.tRightImage = [self screenShotImageFromViewLayer:tView cutSize:CGRectMake(-tFrame.size.width / 2, 0, tFrame.size.width / 2, tFrame.size.height)];
    
//    UIImageView *fImageView = [[UIImageView alloc]initWithFrame:CGRectMake(fFrame.origin.x, fFrame.origin.y, fFrame.size.width / 2, fFrame.size.height)];
//    fImageView.image = self.fLeftImage;
//    [self.view addSubview:fImageView];

//    UIImageView *tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tFrame.size.width / 2 + tFrame.origin.x, tFrame.origin.y, tFrame.size.width / 2, tFrame.size.height)];
//    tImageView.image = self.tRightImage;
//    [self.view addSubview:tImageView];
    
    [fView removeFromSuperview];
    //[tView removeFromSuperview];
    
    UIImageView *removeImageView = [[UIImageView alloc]init];
    removeImageView.image = self.tLeftImage;
    [removeImageView.layer setAnchorPoint:CGPointMake(0, 0.5)];
    removeImageView.frame = CGRectMake(tFrame.size.width / 2 + tFrame.origin.x, tFrame.origin.y, tFrame.size.width / 2, tFrame.size.height);
    [self.view addSubview:removeImageView];
    self.removeImageView = removeImageView;

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pageAnimation:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)pageAnimation:(UIPanGestureRecognizer *)pan {
    //NSLog(@"begin");
    CGPoint beginPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        beginPoint = [pan translationInView:pan.view];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [pan translationInView:pan.view];
        
        CGFloat width = fabs(point.x - beginPoint.x);
        double angel = (100 - width)/ 100.0;
        if (width > 100) {
            angel = 0;
        }
        if (point.x - beginPoint.x > 0) {//向右滑 -》
            
        } else {//向左滑 《-
            if (angel >= 0.5) {
                angel = 1;
            } else {
                angel = 0;
            }
            self.removeImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI * angel + M_PI, 0, 1, 0);
        }
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:pan.view];
        NSLog(@"x:%f y:%f",point.x,point.y);
        
        CGFloat width = fabs(point.x - beginPoint.x);
        double angel = (100 - width)/ 100.0;
        if (width > 100) {
            angel = 0;
        }
        if (point.x - beginPoint.x > 0) {//向右滑 -》
            
        } else {//向左滑 《-
            if (angel >= 0.5) {
                self.removeImageView.image = self.fRightImage;
            } else {
                self.removeImageView.image = self.tLeftImage;
            }
            self.removeImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI * angel + M_PI, 0, 1, 0);
        }
        
        
    }
}



@end
