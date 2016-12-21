//
//  UIColor+QHFace.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "UIColor+QH.h"

@implementation UIColor (QH)

+ (UIColor *)qh_colorWithHex:(NSInteger)hex
{
    return [UIColor qh_colorWithHex:hex
                                alpha:1.0];
}

+ (UIColor *)qh_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hex & 0XFF0000) >> 16) / 255.0
                           green:((hex & 0X00FF00) >> 8)  / 255.0
                            blue:(hex & 0X0000FF)         / 255.0
                           alpha:alpha];
}

@end
