//
//  PageAnimation.m
//  reactivecocoa
//
//  Created by zhaoxin_dev on 2017/9/5.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "PageAnimation.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface PageAnimation ()

@end

@implementation PageAnimation


+ (void)convertViewFromView:(UIView *)fView toView:(UIView *)tView finished:(void (^)(BOOL))finished{
    UIView *selfView = fView.superview;
    
    [fView removeFromSuperview];
    [tView removeFromSuperview];
    
    CGRect fFrame = fView.frame;
    CGRect tFrame = tView.frame;
    
    tView.frame = CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height);
    [tView.layer setTransform:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
    
    fView.frame = CGRectMake(0, 0, fView.frame.size.width, fView.frame.size.height);
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:fFrame];
    backView.image = [self transImageFromView:fView];
    [selfView addSubview:backView];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation2.fromValue = @(0);
    animation2.toValue = @(M_PI_2);
    animation2.duration = 1.25;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    [backView.layer addAnimation:animation2 forKey:@"ani2"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        backView.image = [self transImageFromView:tView];
        backView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
        
        CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        animation3.fromValue = @(M_PI_2);
        animation3.toValue = @(M_PI);
        animation3.duration = 1.25;
        //animation2.repeatCount = HUGE_VALF;
        animation3.autoreverses = NO;
        animation3.removedOnCompletion = NO;
        animation3.fillMode = kCAFillModeForwards;
        [backView.layer addAnimation:animation3 forKey:@"ani2"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [backView removeFromSuperview];
            
            tView.frame = tFrame;
            fView.frame = fFrame;
            tView.layer.transform = CATransform3DIdentity;
            [selfView addSubview:tView];
            
            finished(YES);
        });
    });
}

+ (UIImage *)transImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)transTranslateImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, -view.frame.origin.x, -view.frame.origin.y);
    [view.layer renderInContext:context];
    
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CATransform3D)TransForm3DWithAngle:(CGFloat)angle{
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34= -2.0/2000;
    
    transform=CATransform3DRotate(transform,angle,1,0,0);
    
    return transform;
    
}

//手滑动翻页
- (UIImage *)screenShotImageFromView:(UIView *)view cutSize:(CGRect )rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    
    [view.layer renderInContext:context];
    
    CGContextRestoreGState(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsGetCurrentContext();
    
    return newImage;
}

- (void)addPanGuestureFromView:(UIView *)fView toView:(UIView *)tView {
    UIView *selfView = fView.superview;
    
    CGRect fFrame = fView.frame;
    CGRect tFrame = tView.frame;
    
    UIImage *fLeftImage = [self screenShotImageFromView:fView cutSize:CGRectMake(0, 0, fFrame.size.width / 2, fFrame.size.height)];
    UIImage *fRightImage = [self screenShotImageFromView:fView cutSize:CGRectMake(-fFrame.size.width / 2, 0, fFrame.size.width / 2, fFrame.size.height)];
    UIImage *tLeftImage = [self screenShotImageFromView:tView cutSize:CGRectMake(0, 0, tFrame.size.width / 2, tFrame.size.height)];
    UIImage *tRightImage = [self screenShotImageFromView:tView cutSize:CGRectMake(-tFrame.size.width / 2, 0, tFrame.size.width / 2, tFrame.size.height)];
    
    UIImageView *fImageView = [[UIImageView alloc]initWithFrame:CGRectMake(fFrame.origin.x, fFrame.origin.y, fFrame.size.width / 2, fFrame.size.height)];
    fImageView.userInteractionEnabled = YES;
    fImageView.image = fLeftImage;
    [selfView addSubview:fImageView];
    
    UIImageView *tImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tFrame.size.width / 2 + tFrame.origin.x, tFrame.origin.y, tFrame.size.width / 2, tFrame.size.height)];
    tImageView.userInteractionEnabled = YES;
    tImageView.image = tRightImage;
    [selfView addSubview:tImageView];
    
    [fView removeFromSuperview];
    [tView removeFromSuperview];
    
    UIImageView *removeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tFrame.size.width / 2 + tFrame.origin.x, tFrame.origin.y, tFrame.size.width / 2, tFrame.size.height)];
    removeImageView.userInteractionEnabled = YES;
    removeImageView.image = fRightImage;
    [selfView addSubview:removeImageView];
    
    selfView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pageAnimation:)];
    [selfView addGestureRecognizer:panGesture];
}

- (void)pageAnimation:(UIPanGestureRecognizer *)pan {
    //NSLog(@"begin");
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:pan.view];
        NSLog(@"x:%f y:%f",point.x,point.y);
    }
}


@end
