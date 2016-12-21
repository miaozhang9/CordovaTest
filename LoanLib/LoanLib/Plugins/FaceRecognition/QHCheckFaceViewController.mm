//
//  QHCheckFaceViewController.m
//  PANewToapAPP
//
//  Created by wuyp on 16/3/30.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#if !TARGET_OS_SIMULATOR
#import "PAFaceCheck.h"
#endif

#import "QHCheckFaceViewController.h"
#import "QHCheckFaceFailViewController.h"
#import "UIImage+QH.h"
#import "QHMasonry.h"

#define BACKTOGUIDEPAGENOTIFICATION @"BackToGuidePageNotification"

@interface QHCheckFaceViewController ()

#if !TARGET_IPHONE_SIMULATOR
<PACheckDelegate>
#endif

@property (nonatomic, strong ) UIImageView          *faceImageView;

@property (nonatomic, strong ) UIButton            *okButton;

@property (nonatomic, strong ) NSMutableArray       *uploadImageIdArr;  /**< 上传的图片ID集合 */

@property (nonatomic, assign ) BOOL                 isPushFailView;     /**< 是否已经显示人脸识别失败页 */

@property (nonatomic, assign ) BOOL                 isFail;             /**< 上传图片过程中是否失败 */

@property (nonatomic, assign ) NSInteger            completedCount;     /**< 请求完成的数量 */

@end

@implementation QHCheckFaceViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"刷脸认证";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnAction)];

    [self setupLayout];
}

- (void)leftBarBtnAction{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


#pragma mark - Init

- (void)setupLayout {
    [self.view addSubview:self.faceImageView];
    [self.view addSubview:self.okButton];
    
    __weak typeof(self) weakSelf = self;
//    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.view).offset(-20);
//        make.height.mas_equalTo(48);
//        make.left.equalTo(weakSelf.view).offset(14);
//        make.right.equalTo(weakSelf.view).offset(-14);
//    }];

//    
//    [_faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.okButton).offset(-102);
//        make.centerX.equalTo(weakSelf.view);
//    }];
    _faceImageView.frame = CGRectMake(0, 0, 150, 150);
    _faceImageView.center = self.view.center;
    _faceImageView.backgroundColor = [UIColor yellowColor];

    self.okButton.frame = CGRectMake(0, 300, 100, 200);

}

#pragma mark - override

/**
 *  返回引导页
 */
- (void)leftBtnItemAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:BACKTOGUIDEPAGENOTIFICATION object:nil];
}

#pragma mark - event

- (void)startCheckFace:(UIButton *)sender {

    [self qh_startLiveness];
}

#pragma mark - private

/**
 *  调用人脸识别
 */
- (void)qh_startLiveness {
#if !TARGET_IPHONE_SIMULATOR
    NSString *environment;
//    if ([[SystemConfigure shareSystemConfigure] isProductionEnvironment]) {
//        environment = @"PAEnvironment_Prd";
//    } else {
//        environment = @"PAEnvironment_Stg";
//    }
//    
//    NSString *uuid = [QHTools getDeviceID];
//    QHLoginUserInfoModel *model = [[QHUserManager sharedInstance] currentUserInfo];
//    NSString *cardID = model.idNo;
//    
    NSMutableDictionary *environmentDict = [[NSMutableDictionary alloc]init];
//    [environmentDict setValue:environment forKey:@"environment"];
//    [environmentDict setValue:uuid forKey:@"terminalId"];
//    [environmentDict setValue:@"184DACA6F7B41B2AE0531580140A5EB4" forKey:@"appKey"];
//    [environmentDict setValue:@"571294" forKey:@"subSystemId"];
    [environmentDict setValue:@"com.pingan.qh" forKey:@"boundId"];
//    [environmentDict setValue:@"AAAA" forKey:@"randomStr"],
//    [environmentDict setValue:@"c8c891af95754127107e7e2c2b2e1df391df08ec" forKey:@"token"];
//    [environmentDict setValue:@"https://opraeams-bank.pingan.com.cn/opra-eams-portal/face" forKey:@"url"];
    [PAFaceCheck setFaceEnvironmentWithDict:environmentDict];
    
    //请确保Bundle Identifier 为com.pingan.*  否则可能会报错
    PAFaceCheck *faceVC = [[PAFaceCheck alloc] initWithPAcheck:PACheck_FaceRecognization cardId:@"" andTheInterfaceType:@"0" andTheSoundContor:YES andTheFaceControls:YES andQualitySwitch:YES andTheCountdown:YES andTheSimplificationContor:YES andTheGlassesSwitch:YES andTheAdvertising:nil delegate:self];
//    [self presentViewController:faceVC animated:YES completion:nil];
#endif
}

/**
 *  提交活体信息
 */
- (void)submitLivingInfo {
    __weak typeof(self) weakSelf = self;
//    [self.kydApplyPresenter requestSubmitFaceImgWithLivingInfo:self.uploadImageIdArr successAction:^(QHGPModel *model, id OtherInfo) {
//        [QHProgressHUD dismiss];
//        if (model.success) {
//            QHPhoneAuthenticationViewController *vc = [[QHPhoneAuthenticationViewController alloc] init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        } else {
//            [weakSelf qh_pushCheckFaceFailView];
//        }
//        
//    } failureAction:^(NSError *error, id OtherInfo) {
//        [QHProgressHUD dismiss];
//        [weakSelf qh_pushCheckFaceFailView];
//    }];
}

/**
 *  当刷脸失败时，弹出失败页
 */
- (void)qh_pushCheckFaceFailView {
    QHCheckFaceFailViewController *failVC = [[QHCheckFaceFailViewController alloc] init];
    [self.navigationController pushViewController:failVC animated:YES];
}

/**
 *  等比例缩小
 *
 *  @param sourceImage 原始图片
 *  @param defineWidth 目标图片宽度
 *
 *  @return 缩小后图片
 */
- (UIImage *)qh_imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContext(thumbnailRect.size);
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  图片方向修正
 *
 *  @param aImage 传入图片
 *
 *  @return 修正方向后返回图片
 */
- (UIImage *)qh_fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
    {
        return aImage;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            
            break;
            
        default:
            
            break;
            
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            
            break;
            
        default:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            
            break;
            
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark - SDK三个回调
#if !TARGET_IPHONE_SIMULATOR
// 成功拍摄后的回调（andTheInterfaceType 为”0”时有此回调）
-(int)getPacheckreportWithImage:(UIImage *)picture andTheFaceImage:(UIImage *)faceImage andTheFaceImageInfo:(NSDictionary *)imageInfo andTheResultCallBlacek:(PAFaceCheckBlock)completion{
    self.uploadImageIdArr = [[NSMutableArray alloc] init];
    
    // 如下代码为人脸验证SDK必需
    NSMutableDictionary *resuDict = [[NSMutableDictionary alloc]init];
    [resuDict setValue:@"易认证回调" forKey:@"成功检测到人脸"];
    if (completion) {
        completion (resuDict);
    }
    
    // 调整压缩图片
//    UIImage *compressImage = [self qh_imageCompressForWidth:[self qh_fixOrientation:faceImage] targetWidth:300];

    [self sendImageToJSPicturePhoto:picture facePhoto:faceImage imageInfo:imageInfo];

//    [QHProgressHUD showWithStatus:@"成功检测到人脸,正在验证" maskType:QHProgressHUDMaskTypeBlack maskWithout:QHProgressHUDMaskWithoutNavigation];

    __weak typeof(self) weakSelf = self;
    //上传图片
//    [self.kydApplyPresenter uploadImageToPPS:compressImage type:@"" successAction:^(id model, QHKydOCRUserInfoModel *userInfo, id otherInfo, BOOL getTicket) {
//        if (getTicket) { //Ticket获取成功
//            if ([model isKindOfClass:[QHDaiNiHuanUploadResultModel class]]) {
//                QHDaiNiHuanUploadResultModel *temp = (QHDaiNiHuanUploadResultModel *)model;
//                
//                if (!temp.success) { //OCR扫描失败
//                    [QHProgressHUD dismiss];
//                    [weakSelf qh_pushCheckFaceFailView];
//                    return;
//                }
//                
//                [weakSelf.uploadImageIdArr addObject:temp.picRecordId];
//                //OCR全部扫描成功-->提交活体信息
//                [weakSelf submitLivingInfo];
//            }
//        } else {
//            [QHProgressHUD dismiss];
//            [weakSelf qh_pushCheckFaceFailView];
//        }
//    } failureAction:^(NSError *error, id otherInfo) {
//        [QHProgressHUD dismiss];
//        [weakSelf qh_pushCheckFaceFailView];
//    }];
    
    return 0;
}

/*!
 *  每一个活体动作检测的代理回调方法
 *  @param faceReport   单步检测失败数据字典
 *  @param error        检测失败报错
 */
//失败的report回调
- (void)getPAcheckReport:(NSDictionary *)faceSingleReport error:(NSError *)error andThePAFaceCheckdelegate:(id)delegate{
    // 推入失败页面
    [self qh_pushCheckFaceFailView];
    if (self.faceRecognitionComplete) {
        self.faceRecognitionComplete(NO, nil, nil, nil);
    }
}

// 失败回调
- (void)getSinglePAcheckReport:(NSDictionary *)singleReport error:(NSError *)error andThePAFaceCheckdelegate:(id)delegate {
    [self qh_pushCheckFaceFailView];
    if (self.faceRecognitionComplete) {
        self.faceRecognitionComplete(NO, nil, nil, nil);
    }
}

- (void)sendImageToJSPicturePhoto:(UIImage *)picPhoto facePhoto:(UIImage *)facePhoto imageInfo:(NSDictionary *)info{

    if (!picPhoto || !facePhoto) return ;

    __block NSString *picPhotoPath = @"";
    __block NSString *facePhotoPath = @"";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HHmmss";
    NSString *datePrefix = [dateFormatter stringFromDate:[NSDate date]];

    [picPhoto qh_saveImageName:[NSString stringWithFormat:@"qhBigFace_time%@_w%.0f_h%.0f.jpg", datePrefix, picPhoto.size.width, picPhoto.size.height] callBack:^(NSString *imagePath) {
        picPhotoPath = imagePath;
        [facePhoto qh_saveImageName:[NSString stringWithFormat:@"qhSmallFace_time%@_w%.0f_h%.0f.jpg", datePrefix, facePhoto.size.width, facePhoto.size.height] callBack:^(NSString *imagePath) {
            facePhotoPath = imagePath;
        }];
    }];
    if (self.faceRecognitionComplete) {
        self.faceRecognitionComplete(YES, picPhotoPath, facePhotoPath, info);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#endif

#pragma mark - getter & setter

- (UIImageView *)faceImageView {
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kyd_checkFace"]];
    }
    
    return _faceImageView;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_okButton setTitle:@"开始刷脸" forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(startCheckFace:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _okButton;
}

@end
