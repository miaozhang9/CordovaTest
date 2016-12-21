//
//  UIImage+QH.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/17.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "UIImage+QH.h"

@implementation UIImage (QH)

#pragma mark  保存图片到document

- (BOOL)qh_saveImageName:(NSString *)imageName callBack:(void(^)(NSString *imagePath))callBack{

    NSString *path = [self qh_getImageDocumentFolderPath];
    NSData *imageData = UIImagePNGRepresentation(self);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", path];
    // Now we get the full path to the file
    NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件路径存在的话
    BOOL bRet = [fileManager fileExistsAtPath:imageFile];
    if (bRet)
    {
        //        NSLog(@"文件已存在");
        if ([fileManager removeItemAtPath:imageFile error:nil])
        {
            //            NSLog(@"删除文件成功");
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                //                NSLog(@"保存文件成功");
                callBack(imageFile);
            }
        }
        else
        {

        }
    }
    else
    {
        BOOL success = [imageData writeToFile:imageFile atomically:YES];
        if (!success)
        {
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                callBack(imageFile);
            }
        }
        else
        {
            callBack(imageFile);
            return YES;
        }

    }
    return NO;
}

#pragma mark  从文档目录下获取Documents路径

- (NSString *)qh_getImageDocumentFolderPath{

    NSString *patchDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSString stringWithFormat:@"%@/Images", patchDocument];
}

@end
