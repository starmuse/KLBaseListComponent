//
//  UIView+Categories.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/11.
//

#import "UIView+Categories.h"

@implementation UIView (Categories)

- (void)kl_addRoundedCornersRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
