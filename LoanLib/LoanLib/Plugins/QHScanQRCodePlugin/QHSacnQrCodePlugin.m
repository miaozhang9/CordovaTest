//
//  QHSacnQrCodePlugin.m
//  HelloWorld
//
//  Created by guopengwen on 16/12/15.
//  Copyright © 2016年 guopengwen. All rights reserved.
//

#import "QHSacnQrCodePlugin.h"
#import "QHScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation QHSacnQrCodePlugin

- (void)sacnQrCode:(QHInvokedUrlCommand*)command{
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsString:@"No camera available"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        QHScanQRCodeViewController *vc = [QHScanQRCodeViewController new];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self.viewController presentViewController:navVC animated:YES completion:nil];
    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancle" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:Nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (UIApplicationOpenSettingsURLString != NULL) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        } ]];
    }
}

@end
