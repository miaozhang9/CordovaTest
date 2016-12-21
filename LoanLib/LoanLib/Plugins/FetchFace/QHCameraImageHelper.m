//
//  QHCameraImageHelper.m
//  YiZhangTong_iOS_Common
//
//  Created by 张久修 on 16/4/28.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHCameraImageHelper.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
//#import "UIImage+QH.h"
//#import "QHGlobalDefine.h"

@implementation QHCameraImageHelper

#pragma mark - life cycle

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>)aDelegate embedPreviewInView:(UIView *)view fullImage:(BOOL) flag {
    self.isFullImage = flag;
    return [self initWithDelegate:aDelegate embedPreviewInView:view];
}

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>) aDelegate embedPreviewInView:(UIView *)view {
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        [self qh_initialize];
        [self qh_embedPreviewInView:view];
        [self qh_changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<QHCameraImageHelperDelegate>)aDelegate embedPreviewInView:(UIView *)view fullImage:(BOOL) flag front:(BOOL)front{
    self = [super init];
    if (self) {
        self.isFullImage = flag;
        self.isFront = front;
        self.delegate = aDelegate;
        [self qh_initialize];
        [self qh_embedPreviewInView:view];
        [self qh_changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    return self;
}

- (void) dealloc {
    
    [self qh_deallocSession];
}

#pragma mark - private

- (void)qh_initialize {
    //获取前后摄像头
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        //QHLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                //QHLog(@"Device position : back");
                backCamera = device;
            }
            else {
                //QHLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    //前置摄像头调取失败
    if (_isFront && !frontCamera) {
        return;
    }
    //主摄像头
    if (!_isFront && !backCamera) {
        return;
    }
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_isFront?frontCamera:device error:&error];
    if (!captureInput) {
        return;
    }
    [self.session addInput:captureInput];
    
    //3.创建、配置输出
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    
    [self.captureOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.captureOutput];
}

- (void)qh_embedPreviewInView: (UIView *)aView
{
    if (!self.session) {
        return;
    }
    //设置取景
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer:self.preview];
}

- (void)qh_changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.preview) {
        return;
    }
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.g_orientation = UIImageOrientationUp;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.g_orientation = UIImageOrientationDown;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortrait){
        self.g_orientation = UIImageOrientationRight;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        self.g_orientation = UIImageOrientationLeft;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}

-(void)qh_deallocSession
{
    if (self.preview && self.preview.superlayer) {
        
        [self.preview removeFromSuperlayer];
    }
    
    if (self.session) {
        if (self.session.inputs) {
            for(AVCaptureInput *input1 in self.session.inputs) {
                [self.session removeInput:input1];
            }
        }
        
        if (self.session.outputs) {
            for(AVCaptureOutput *output1 in self.session.outputs) {
                [self.session removeOutput:output1];
            }
        }
        [self stopRunning];
    }
    self.session=nil;
    self.image = nil;
    self.captureOutput = nil;
    self.preview = nil;
}

#pragma mark Class Interface

- (void)startRunning {
    [[self session] startRunning];
}

- (void) stopRunning {
    [[self session] stopRunning];
}

-(void)captureStillImage {
    [self captureimage];
}

-(void)captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *t_image = [UIImage imageWithData:imageData];
             self.image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1 orientation:UIImageOrientationRight];
             if (!self.isFullImage) {
                 float minSize = MIN(self.image.size.width, self.image.size.height);
                 //限制宽高不超过320
                 int count = 2;
                 
//                 if (self.isFromAddCarOCR)
//                 {
//                     if (minSize >= count*QHScreenWidth) {
//                         float scaleValue = count*QHScreenWidth/minSize;
//                         self.image = [self.image qh_scaleImageToScale:scaleValue];
//                     }
//                     self.image = [self.image qh_getSubImageInRect:CGRectMake(count*2*Grid_a,
//                                                                               count*((QHScreenWidth*4/3 - 36*Grid_a + 8*Grid_a/3)/2),
//                                                                               count*56*Grid_a,
//                                                                               count*36*Grid_a)];
//                 }
//                 else
//                 {
//                     if (minSize >= count*320.0) {
//                         float scaleValue = count*320.0/minSize;
//                         self.image = [self.image qh_scaleImageToScale:scaleValue];
//                     }
//                     self.image = [self.image qh_getSubImageInRect:CGRectMake(0, count*115, count*320, count*200)];
//                 }
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedCapture:)]) {
                 [self.delegate didFinishedCapture:self.image];
             }
         }
     }];
}
@end
