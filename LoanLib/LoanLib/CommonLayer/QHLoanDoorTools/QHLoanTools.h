//
//  QHLoanTools.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/20.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHLoanTools : NSObject
/*
 *  filePath 要删除的文件路径
 *  return 删除成功与否
 */
+ (BOOL)qh_deleteFile:(NSString *)filePath;

@end
