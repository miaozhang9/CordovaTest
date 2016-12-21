//
//  UIImage+QH.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/17.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QH)

- (BOOL)qh_saveImageName:(NSString *)imageName callBack:(void(^)(NSString *imagePath))callBack;

@end
