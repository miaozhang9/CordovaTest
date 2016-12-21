//
//  NSFileManager+QH.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/20.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "NSFileManager+QH.h"

@implementation NSFileManager (QH)

+ (BOOL)qh_deleteFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:filePath error:&error];
    return error == nil;
}

@end
