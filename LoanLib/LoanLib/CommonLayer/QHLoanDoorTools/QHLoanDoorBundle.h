//
//  QHLoanDoorTools.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHLoanDoorBundle : NSObject

+ (NSBundle *)bundle;

+ (NSString *)filePath:(NSString *)fileName;

+ (NSString *)filePath:(NSString *)fileName type:(NSString *)type;

+ (NSString *)version;

@end
