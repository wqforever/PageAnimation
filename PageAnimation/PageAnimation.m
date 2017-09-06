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


@end
