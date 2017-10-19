//
//  UILabel+scroll.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/10/19.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "UILabel+scroll.h"

static const void *scrollKey = @"scrollKey";
static const void *kNewLabel = @"newlabel";
static const void *kNewLabel2 = @"newlabel2";
static const void *textStr = @"textStr";

@interface UILabel ()
/** <#描述#> */
@property (nonatomic, strong) UILabel *newLabel;
/** <#描述#> */
@property (nonatomic, strong) UILabel *newLabel2;
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

- (UILabel *)newLabel {
    return objc_getAssociatedObject(self, &kNewLabel);
}

- (void)setNewLabel:(UILabel *)newLabel {
    objc_setAssociatedObject(self, &kNewLabel, newLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)newLabel2 {
    return objc_getAssociatedObject(self, &kNewLabel2);
}

- (void)setNewLabel2:(UILabel *)newLabel2 {
    objc_setAssociatedObject(self, &kNewLabel2, newLabel2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)textContent {
    return objc_getAssociatedObject(self, &textStr);
}

- (void)setTextContent:(NSString *)textContent {
    objc_setAssociatedObject(self, &textStr, textContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)horizonScroll {
    NSLog(@"横向滚动");
    self.layer.masksToBounds = YES;
    
    CGRect frame = self.frame;
    float sWidth = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + 1;
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sWidth, frame.size.height)];
    newLabel.text = self.text;
    newLabel.font = self.font;
    newLabel.textColor = self.textColor;
    newLabel.textAlignment = self.textAlignment;
    [self addSubview:newLabel];
    self.newLabel = newLabel;
    
    UILabel *newLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(sWidth + 20, 0, sWidth, frame.size.height)];
    newLabel2.text = self.text;
    newLabel2.font = self.font;
    newLabel2.textColor = self.textColor;
    newLabel2.textAlignment = self.textAlignment;
    [self addSubview:newLabel2];
    self.newLabel2 = newLabel2;
    
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
    animation.duration = (sWidth * 2 + 40) * 0.01;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timeOffset = (sWidth + 20) * 0.01;
    [layer addAnimation:animation forKey:@"animation"];
}

- (void)setNewAnimationFromLayer:(CALayer *)layer{
    [layer removeAllAnimations];
    CGRect frame = self.frame;
    float sWidth = [self.textContent boundingRectWithSize:CGSizeMake(MAXFLOAT, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width + 1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(sWidth / 2 + sWidth + 20, frame.size.height / 2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-sWidth / 2 - 20, frame.size.height / 2)];
    animation.duration = (sWidth * 2 + 40) * 0.01;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:@"animation2"];

}



@end
