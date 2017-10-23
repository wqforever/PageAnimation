//
//  UILabel+scroll.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/10/19.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "UILabel+scroll.h"

static const void *scrollKey = @"scrollKey";
static const void *textStr = @"textStr";

#define ScrollSpeed 0.01

@interface UILabel ()
/** <#描述#> */
@property (nonatomic, copy) NSString *textContent;

@end

@implementation UILabel (scroll)


- (BOOL)isCanScroll {
    return [objc_getAssociatedObject(self, &scrollKey) boolValue];
}

- (void)setIsCanScroll:(BOOL)isCanScroll {
    if (isCanScroll) {
        [self horizonScroll];
    }
    
    objc_setAssociatedObject(self, &scrollKey, [NSNumber numberWithBool:isCanScroll], OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)textContent {
    return objc_getAssociatedObject(self, &textStr);
}

- (void)setTextContent:(NSString *)textContent {
    objc_setAssociatedObject(self, &textStr, textContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)horizonScroll {
    //NSLog(@"横向滚动");
    self.layer.masksToBounds = YES;
    
    CGRect frame = self.frame;
    float sWidth = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + 1;
    if (sWidth <= frame.size.width) {
        return;
    }
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sWidth, frame.size.height)];
    newLabel.text = self.text;
    newLabel.font = self.font;
    newLabel.textColor = self.textColor;
    newLabel.textAlignment = self.textAlignment;
    [self addSubview:newLabel];
    
    
    UILabel *newLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(sWidth + 20, 0, sWidth, frame.size.height)];
    newLabel2.text = self.text;
    newLabel2.font = self.font;
    newLabel2.textColor = self.textColor;
    newLabel2.textAlignment = self.textAlignment;
    [self addSubview:newLabel2];
    
    
    self.textContent = self.text;
    
    [self setAnimationFromLayer:newLabel.layer];
    
    [self setNewAnimationFromLayer:newLabel2.layer];
    
    self.text = @"";
    
}

- (void)setAnimationFromLayer:(CALayer *)layer{
    [layer removeAllAnimations];
    CGRect frame = self.frame;
    
    float sWidth = [self.textContent boundingRectWithSize:CGSizeMake(MAXFLOAT, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + 1;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(sWidth / 2 + sWidth + 20, frame.size.height / 2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-sWidth / 2 - 20, frame.size.height / 2)];
    animation.duration = (sWidth * 2 + 40) * ScrollSpeed;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timeOffset = (sWidth + 20) * ScrollSpeed;
    [layer addAnimation:animation forKey:@"animation"];
}

- (void)setNewAnimationFromLayer:(CALayer *)layer{
    [layer removeAllAnimations];
    CGRect frame = self.frame;
    float sWidth = [self.textContent boundingRectWithSize:CGSizeMake(MAXFLOAT, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + 1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(sWidth / 2 + sWidth + 20, frame.size.height / 2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-sWidth / 2 - 20, frame.size.height / 2)];
    animation.duration = (sWidth * 2 + 40) * ScrollSpeed;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:@"animation2"];

}



@end
