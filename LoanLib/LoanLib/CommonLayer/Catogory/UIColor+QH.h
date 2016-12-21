//
//  UIColor+QHFace.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QH)

+ (UIColor *)qh_colorWithHex:(NSInteger)hex;

+ (UIColor *)qh_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end
