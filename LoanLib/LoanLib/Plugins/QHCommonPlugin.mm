//
//  QHHaleyPlugin.m
//  HelloCordova
//
//  Created by Harvey on 16/9/28.
//
//

#import <AVFoundation/AVFoundation.h>
#import "QHCheckFaceViewController.h"
#import "QHCommonPlugin.h"
#import "QHFetchFaceViewController.h"
#import "QHLoanDoorBundle.h"
#import "NSFileManager+QH.h"

#if !TARGET_OS_SIMULATOR
#import "PAFaceCheck.h"
#import "QHFaceCheckDelegate.h"
#endif

@implementation QHCommonPlugin

- (void)version:(QHInvokedUrlCommand *)command{
    [self.commandDelegate runInBackground:^{
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:[QHLoanDoorBundle version]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)scan:(QHInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"原生弹窗" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        });
    }];
}

- (void)location:(QHInvokedUrlCommand *)command
{
    // 获取定位信息......
    
    // 下一行代码以后可以删除
//    NSString *locationStr = @"广东省深圳市南山区学府路XXXX号";
    NSString *locationStr = @"错误信息";
    
//    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",locationStr];
//    [self.commandDelegate evalJs:jsStr];
    
    [self.commandDelegate runInBackground:^{
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsString:locationStr];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)pay:(QHInvokedUrlCommand *)command
{
    // 这里是支付的相关代码......
    
    // 以下代码以后可以删除
    NSUInteger code = 1;
    NSString *tip = @"支付成功";
    NSArray *arguments = command.arguments;
    if (arguments.count < 4) {;
        code = 2;
        tip = @"参数错误";
    } else {
        NSLog(@"从H5获取的支付参数:%@",arguments);
    }
    
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@',%lu)",tip,(unsigned long)code];
    [self.commandDelegate evalJs:jsStr];
}

- (void)share:(QHInvokedUrlCommand *)command
{
    NSUInteger code = 1;
    NSString *tip = @"分享成功";
    NSArray *arguments = command.arguments;
    if (arguments.count < 3) {;
        code = 2;
        tip = @"参数错误";
        NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@')",tip];
        [self.commandDelegate evalJs:jsStr];
        return;
    }
    
    NSLog(@"从H5获取的分享参数:%@",arguments);
    NSString *title = arguments[0];
    NSString *content = arguments[1];
    NSString *url = arguments[2];
    
    // 这里是分享的相关代码......
    
    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.commandDelegate evalJs:jsStr];
}

- (void)changeColor:(QHInvokedUrlCommand *)command
{
    NSArray *arguments = command.arguments;
    if (arguments.count < 4) {
        return;
    }
    
    CGFloat r = [arguments[0] floatValue];
    CGFloat g = [arguments[1] floatValue];
    CGFloat b = [arguments[2] floatValue];
    CGFloat a = [arguments[3] floatValue];
    
    self.viewController.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (void)faceRecognition:(QHInvokedUrlCommand *)command{

#if !TARGET_OS_SIMULATOR
    NSString *environment;
    NSMutableDictionary *environmentDict = [[NSMutableDictionary alloc]init];
    [environmentDict setValue:@"com.pingan.qh" forKey:@"boundId"];
    [PAFaceCheck setFaceEnvironmentWithDict:environmentDict];

    QHFaceCheckDelegate *delegate = [QHFaceCheckDelegate shareDelegate];

    [delegate setFaceRecognitionComplete:^(BOOL isSuccess, NSString *picPath, NSString *facePath, NSDictionary *otherInfo) {
        // 将获取头像结果返回给js
        [self.commandDelegate runInBackground:^{
            QHPluginResult *result = nil;
            if (isSuccess) {
                result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:facePath];
            }
            else{
                result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsString:@"获取头像失败！"];
            }
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    }];

    PAFaceCheck *faceVC = [[PAFaceCheck alloc] initWithPAcheck:PACheck_FaceRecognization cardId:@"" andTheInterfaceType:@"0" andTheSoundContor:YES andTheFaceControls:YES andQualitySwitch:YES andTheCountdown:YES andTheSimplificationContor:YES andTheGlassesSwitch:YES andTheAdvertising:nil delegate:delegate];
    [self.viewController presentViewController:faceVC animated:YES completion:nil];

#endif

}

- (void)camaraFetchFace:(QHInvokedUrlCommand *)command{
    QHFetchFaceViewController *faceCtrl = [[QHFetchFaceViewController alloc] init];
    [faceCtrl setFetchFaceComplete:^(NSString *imagePath) {
        [self.commandDelegate runInBackground:^{
            QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:imagePath];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    }];
    [self.viewController presentViewController:faceCtrl animated:YES completion:nil];
}

- (void)deleteFile:(QHInvokedUrlCommand *)command{
    if (command.arguments.count == 0) {
        [self.commandDelegate sendPluginResult:[QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsBool:NO] callbackId:command.callbackId];
        return;
    }
    BOOL success = [NSFileManager qh_deleteFile:command.arguments[0]];
    if (success) {
        [self.commandDelegate sendPluginResult:[QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsBool:YES] callbackId:command.callbackId];
    }
    else{
        [self.commandDelegate sendPluginResult:[QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsBool:NO] callbackId:command.callbackId];
    }
}

//- (void)shake:(CDVInvokedUrlCommand *)command
//{
//    [self.commandDelegate runInBackground:^{
//        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
//        [HLAudioPlayer playMusic:@"shake_sound_male.wav"];
//    }];
//}
//
//- (void)playSound:(QHInvokedUrlCommand *)command
//{
//    NSArray *arguments = command.arguments;
//    if (arguments.count < 1) {
//        return;
//    }
//    
//    [self.commandDelegate runInBackground:^{
//        NSString *fileName = arguments[0];
//        [HLAudioPlayer playMusic:fileName];
//    }];
//}

@end
