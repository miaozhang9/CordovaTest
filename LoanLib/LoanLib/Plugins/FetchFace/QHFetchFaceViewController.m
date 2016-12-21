//
//  RealNameAuthFaceAuthViewController.m
//  PANewToapAPP
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHFetchFaceViewController.h"
#import "QHCameraImageHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "QHMasonry.h"
#import "UIImage+QH.h"
#import "QHLoanDoorBundle.h"

@interface QHFetchFaceViewController ()<QHCameraImageHelperDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) QHFetchFaceType type;

@property (nonatomic, strong) UIView *bgViewForCamera;

@property (nonatomic, strong) QHCameraImageHelper *cameraHelper;

@property (nonatomic, strong) UIImageView *personCover;

@property (nonatomic, strong) UIImage *personIcon;

@property (nonatomic, strong) UIView *inputBottomView;

@property (nonatomic, strong) UIView *confirmBottomView;

@end

@implementation QHFetchFaceViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cameraHelper startRunning];
    [self qh_initUI];
    [self qh_addCancelBtnIfPresented];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机权限未开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qh_captureStillImage)]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机权限未开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QHCameraImageHelperDelegate

//获取图片
- (void)didFinishedCapture:(UIImage *)img{
    if (!img) return;
    [self.view layoutIfNeeded];
    _personIcon = img;
    [self.cameraHelper stopRunning];
    self.personCover.hidden = YES;
    self.type = QHFetchFaceTypeConfirmPicture;
}
//聚焦
- (void)foucusStatus:(BOOL)isAdjusting{
    
}

#pragma mark - private

- (void)qh_changeDirection{
    BOOL currentDirection = self.cameraHelper.isFront;
    self.cameraHelper = [[QHCameraImageHelper alloc] initWithDelegate:self embedPreviewInView:self.bgViewForCamera fullImage:YES front:!currentDirection];
    [self.cameraHelper startRunning];
}

- (void)qh_initUI{
    [self.view addSubview:self.bgViewForCamera];
    [self.view addSubview:self.personCover];
    [self.view addSubview:self.confirmBottomView];
    [self.view addSubview:self.inputBottomView];
    __weak typeof(self) weakSelf = self;
    [self.bgViewForCamera qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-[self bottomHeight]);
    }];
    [self.confirmBottomView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.qhMas_equalTo([self bottomHeight]);
    }];
    [self.inputBottomView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.qhMas_equalTo([self bottomHeight]);
    }];
    [self.bgViewForCamera qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-[self bottomHeight]);
    }];
    [self.personCover qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(5);
        make.right.equalTo(weakSelf.view).offset(-5);
        make.top.equalTo(weakSelf.view).offset(55);
        make.bottom.equalTo(weakSelf.bgViewForCamera);
    }];
}

- (void)qh_addCancelBtnIfPresented{
    if (!self.navigationController) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
//        btn.titleLabel.font = QHFont(17);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(leftBtnItemAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        [btn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.right.equalTo(weakSelf.view).offset(-14);
            make.top.equalTo(weakSelf.view).offset(30);
            make.size. qhMas_equalTo(CGSizeMake(40, 20));
        }];
    }
}

- (void)leftBtnItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)qh_captureStillImage{
    [self.cameraHelper captureStillImage];
}

- (UIImage *)qh_image:(UIImage *)oriImage fillSize:(CGSize)viewsize{
    
    NSData *imageData = UIImageJPEGRepresentation(oriImage, 0.07);
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGSize size = image.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *newImageData = UIImageJPEGRepresentation(newImage, 1.0);
    while (newImageData.length/1000 > 98.0) {// 非.length/1024
        newImageData = UIImageJPEGRepresentation(newImage, 0.5);
        newImage = [UIImage imageWithData:newImageData];
    }

    return newImage;
}


- (void)qh_confirm{

     __weak typeof(self) weakSelf = self;
    
    UIImage *sizeImage = [self qh_image:self.personIcon fillSize:CGSizeMake(300, 300)];

    __block NSString *imagePath = @"";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HHmmss";
    NSString *datePrefix = [dateFormatter stringFromDate:[NSDate date]];

    [sizeImage qh_saveImageName:[NSString stringWithFormat:@"qhBigFace_time%@_w%.0f_h%.0f.jpg", datePrefix, sizeImage.size.width, sizeImage.size.height] callBack:^(NSString *imgPath) {
        imagePath = imgPath;
    }];
    if (self.fetchFaceComplete) {
        self.fetchFaceComplete(imagePath);
    }
    [self leftBtnItemAction];
}

- (void)qh_reFetchCamarePicture{
    [self.cameraHelper startRunning];
    self.personCover.hidden = NO;
    self.type = QHFetchFaceTypeGetPicture;
}

#pragma mark - get & set

///拍摄提交底图
- (UIView *)confirmBottomView{
    if (!_confirmBottomView) {
        _confirmBottomView = [[UIView alloc] init];
        _confirmBottomView.backgroundColor = [UIColor whiteColor];
        
        UILabel *warningLab = [[UILabel alloc] init];
//        warningLab.font = QHFont(14);
        warningLab.textColor = [UIColor blackColor];
        warningLab.textAlignment = NSTextAlignmentCenter;
        warningLab.text = @"人脸完整且清晰可见吗？";
        [_confirmBottomView addSubview:warningLab];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.layer.cornerRadius = 24;
        confirmBtn.layer.borderColor = [UIColor blueColor].CGColor;
        confirmBtn.layer.borderWidth = 1.0;
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [confirmBtn addTarget:self action:@selector(qh_confirm) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        [_confirmBottomView addSubview:confirmBtn];
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor colorWithRed:0.21 green:0.59 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(qh_reFetchCamarePicture) forControlEvents:UIControlEventTouchUpInside];
        [self.confirmBottomView addSubview:editBtn];
        __weak typeof(self) weakSelf = self;
        [warningLab qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.confirmBottomView);
            make.top.equalTo(weakSelf.confirmBottomView).offset(24);
            make.height. qhMas_equalTo(warningLab.font.ascender);
        }];
        [confirmBtn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.confirmBottomView);
            make.top.equalTo(warningLab.qhMas_bottom).offset(24);
            make.size.qhMas_equalTo(CGSizeMake(240, 48));
        }];
        [editBtn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.confirmBottomView);
            make.bottom.equalTo(weakSelf.confirmBottomView).offset(-30);
            make.height. qhMas_equalTo(15);
        }];
    }
    return _confirmBottomView;
}

//拍摄底部图
- (UIView *)inputBottomView{
    if (!_inputBottomView) {
        _inputBottomView = [[UIView alloc] init];
        _inputBottomView.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        
        UILabel *guideLab = [[UILabel alloc] init];
        guideLab.font = [UIFont systemFontOfSize:21];
        guideLab.text = @"拍摄证件照人像";
        guideLab.textColor = [UIColor whiteColor];
        guideLab.textAlignment = NSTextAlignmentCenter;
        [_inputBottomView addSubview:guideLab];
        UILabel *dscLab = [[UILabel alloc] init];
        dscLab.textColor = [UIColor whiteColor];
        dscLab.text = @"摘下眼镜拍摄会更容易通过验证喔～";
        dscLab.adjustsFontSizeToFitWidth = YES;
        dscLab.font = [UIFont systemFontOfSize:16];
        dscLab.textAlignment = NSTextAlignmentCenter;
        [_inputBottomView addSubview:dscLab];
        
        UIButton *cameraButton = [[UIButton alloc] init];
        cameraButton.layer.cornerRadius = 37.5;
        cameraButton.layer.borderWidth = 3.0;
        cameraButton.layer.borderColor = [UIColor whiteColor].CGColor;
        cameraButton.clipsToBounds = YES;
        [cameraButton addTarget:self action:@selector(qh_captureStillImage) forControlEvents:UIControlEventTouchUpInside];
        [_inputBottomView addSubview:cameraButton];
        UIView *btnCenter = [[UIView alloc] init];
        btnCenter.backgroundColor = [UIColor whiteColor];
        btnCenter.layer.cornerRadius = 30.0;
        btnCenter.clipsToBounds = YES;
        [cameraButton addSubview:btnCenter];
        
        __weak typeof(self) weakSelf = self;
        [guideLab qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.inputBottomView);
            make.top.equalTo(weakSelf.inputBottomView).offset(30);
            make.height. qhMas_equalTo(guideLab.font.ascender);
        }];
        [dscLab qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.inputBottomView);
            make.top.equalTo(guideLab.qhMas_bottom).offset(10);
            make.height. qhMas_equalTo(dscLab.font.ascender);
        }];
        [cameraButton qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.inputBottomView);
            make.bottom.equalTo(weakSelf.inputBottomView).offset(-20);
            make.size. qhMas_equalTo(CGSizeMake(75, 75));
        }];
        [btnCenter qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.center.equalTo(cameraButton);
            make.size. qhMas_equalTo(CGSizeMake(60, 60));
        }];

    }
    return _inputBottomView;
}

- (QHCameraImageHelper *)cameraHelper{
    if (!_cameraHelper) {
        _cameraHelper = [[QHCameraImageHelper alloc] initWithDelegate:self embedPreviewInView:self.bgViewForCamera fullImage:YES front:YES];
    }
    return _cameraHelper;
}

- (UIView *)bgViewForCamera{
    if (!_bgViewForCamera) {
        _bgViewForCamera = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.view.bounds.size.height-[self bottomHeight])];
        _bgViewForCamera.backgroundColor = [UIColor blackColor];
    }
    return _bgViewForCamera;
}

- (void)setType:(QHFetchFaceType)type{
    _type = type;
    __weak typeof(self) weakSelf = self;
    if (_type == QHFetchFaceTypeGetPicture) {
        [self.view bringSubviewToFront:self.inputBottomView];
    }
    else{
        [self.view bringSubviewToFront:self.confirmBottomView];
    }
}

- (CGFloat)bottomHeight{
    return 200.0;
}

- (UIImageView *)personCover{
    if (!_personCover) {
        _personCover = [[UIImageView alloc] init];
        NSString *imagePath = [QHLoanDoorBundle filePath:@"FetchFace_person.png"];
        _personCover.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return _personCover;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
