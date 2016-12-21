//
//  RealNameAuthFaceAuthViewController.h
//  PANewToapAPP
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "QHCardPackageImageModel.h"

typedef NS_ENUM(NSInteger, QHFetchFaceType){
    QHFetchFaceTypeGetPicture,
    QHFetchFaceTypeConfirmPicture
};

@interface QHFetchFaceViewController : UIViewController

@property (nonatomic, copy) void(^fetchFaceComplete)(NSString *imagePath);

@end
