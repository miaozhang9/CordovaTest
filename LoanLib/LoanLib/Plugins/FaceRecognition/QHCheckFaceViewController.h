//
//  QHCheckFaceViewController.h
//  PANewToapAPP
//
//  Created by wuyp on 16/3/30.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  人脸识别
 */
@interface QHCheckFaceViewController : UIViewController

/// 0、isSuccess 1、picture  2、faceImage 3、otherInfo
@property (nonatomic, copy) void(^faceRecognitionComplete)(BOOL isSuccess, NSString *, NSString *, NSDictionary *);

@end
