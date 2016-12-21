//
//  QHLoanDoor.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QHLoanDoorEnvirenment) {
    QHLoanDoorEnvirenment_stg, //测试环境
    QHLoanDoorEnvirenment_prd, //预发布环境
    QHLoanDoorEnvirenment_pdt, //生产环境
};

@class QHLoanDoorParam;

@interface QHLoanDoor : NSObject

+ (instancetype)share;
/**
 *
 *  version 版本号
 *
 */
+ (NSString *)version;
/**
 *
 *  启动SDK
 *
 *  @param  para  启动参数实体
 *  @param  envirenment 环境配置
 *  @param  successBlock 启动成功回调
 *  @param  failBlock    启动失败回调
 *  @param  shutDownBlock 关闭回调
 *
 */
- (void)launchDoor:(QHLoanDoorParam *)para
       environment:(QHLoanDoorEnvirenment)envirenment
      successBlock:(void(^)())successBlock
         failBlock:(void(^)(NSError *))failBlock
     shutDownBlock:(void(^)())shutDownBlock;

@end


@interface QHLoanDoorParam : NSObject

@end





