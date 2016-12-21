//
//  QHLoanDoorTools.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHLoanDoorBundle.h"

NSString const *QHLoanDoorBundle_Key = @"QHLoanDoorBundle.bundle";

@implementation QHLoanDoorBundle

+ (NSBundle *)bundle{
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:QHLoanDoorBundle_Key];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

+ (NSString *)filePath:(NSString *)fileName{
    return [self filePath:fileName type:nil];
}

+ (NSString *)filePath:(NSString *)fileName type:(NSString *)type{
    return [[self bundle] pathForResource:fileName ofType:type];
}

+ (NSString *)version{
    NSString *dir = [self filePath:@"Info" type:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dir];
    return [dict objectForKey:@"CFBundleVersion"];;
}

@end
