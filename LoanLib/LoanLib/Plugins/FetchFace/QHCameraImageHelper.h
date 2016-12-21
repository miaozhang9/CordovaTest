//
//  QHCameraImageHelper.h
//  YiZhangTong_iOS_Common
//
//  Created by 张久修 on 16/4/28.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol QHCameraImageHelperDelegate;

@interface QHCameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong) UIImage *image;
@property (strong) AVCaptureSession *session;
@property (strong) AVCaptureStillImageOutput *captureOutput;
@property (assign) UIImageOrientation g_orientation;
@property (strong) AVCaptureVideoPreviewLayer *preview;
@property (weak) id<QHCameraImageHelperDelegate> delegate;
@property (assign) BOOL isFullImage;
@property (assign, nonatomic) BOOL isFront;
@property (assign) BOOL isFromAddCarOCR;

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>)aDelegate embedPreviewInView:(UIView *)view;

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>)aDelegate embedPreviewInView:(UIView *)view fullImage:(BOOL) flag;

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>)aDelegate embedPreviewInView:(UIView *)view fullImage:(BOOL) flag front:(BOOL)front;

- (void)captureStillImage;

- (void)startRunning;
- (void)stopRunning;
- (void)qh_changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@protocol QHCameraImageHelperDelegate <NSObject>

//获取图片
- (void)didFinishedCapture:(UIImage *)img;
//聚焦
- (void)foucusStatus:(BOOL)isAdjusting;

@end
