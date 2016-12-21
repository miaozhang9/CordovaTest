//
//  PAFaceCheck.h
//  PAFaceCheck
//
//  Created by ken on 15/5/8.
//  Copyright (c) 2015年 PingAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PAFaceCheckBlock)(NSDictionary *content);

/*!
 *  功能设置类型
 */
typedef enum {
    PACheck_FaceRecognization,      //人脸识别
    PACheck_FaceAndSoundGroove      //人脸识别加声纹识别（未上线）
} PACheckType;

/*!
 *  配置环境
 */
typedef enum {
    PAEnvironment_Prd = 1,      //生产环境
    PAEnvironment_Stg = 2       //测试环境
} PACheckEnvironment;


/*!
 *  全屏图片信息
 */
struct PAFaceImageInfo {
    /** 是否包含人脸 */
    bool has_face = false;
    /** 左右旋转角度 */
    float yaw = 0;
    /** 上下旋转角度 */
    float pitch = 0;
    /** 运动模糊程度 */
    float blurness_motion = 0;
    /** 高斯模糊程度 */
    float blurness_gaussian = 0;
    /** 人脸位置 */
    CGRect face_rect;
    /** 左眼睁闭程度 */
    float eye_left_hwratio = 0;
    /** 右眼睁闭程度 */
    float eye_right_hwratio = 0;
    /** 嘴部睁闭程度 */
    float mouth_hwratio = 0;
    /** 眼镜判定 */
    float glasses = 0;
    /** 亮度 */
    float brightness = 0;
    /** 左眼中心位置坐标 */
    CGPoint eye_left = {0,0};
    /** 右眼中心位置坐标 */
    CGPoint eye_right = {0,0};
    /** 嘴巴中心位置坐标 */
    CGPoint mouth_center = {0,0};
    /** 综合图片质量 */
    float quality = 0;
};



#pragma mark ------------ PAFaceCheck ------------
/*!
 *  活体检测代理方法
 */
@protocol PACheckDelegate <NSObject>
@optional
/*!
 *  每一个活体动作检测的代理回调方法（APP处理网络时，错误回调）
 *  @param faceReport   每一个活体动作检测失败数据字典
 *  @param error        检测失败报错
 */
- (void)getSinglePAcheckReport:(NSDictionary *)singleReport error:(NSError *)error andThePAFaceCheckdelegate:(id)delegate;
;

/*!
 *  活体检测的代理回调方法(APP处理网络则不需要理会)
 *  @param faceReport   检测成功数据字典
 *  其中key有:     imageID       上传照片的流水号
 *              imageInfoArr    活体检测详细数据类数组
                                （5个，第1个为正脸，2到5为每一步对应活体数据）
                                （数据类型 参看PAFaceInfo）
 *
 *  @param faceImage    人脸正面照（即上传到服务器的照片）
 *  @param error        检测失败报错
 */
- (void)getPAcheckReport:(NSDictionary *)faceReport Image:(UIImage *)faceImage error:(NSError *)error;

/*!
 *  APP在此回调处理网络
 *  @param picture   完整图片
 *  @param faceImage    人脸正面照（即上传到服务器的照片）
 *  @param imageInfo    人脸正面照信息（自主选择）
 *  @param completion   回调网络请求结果（字典类型）setCompletionBlock/setFailedBlock
 */
-(int)getPacheckreportWithImage:(UIImage *)picture andTheFaceImage:(UIImage*)faceImage andTheFaceImageInfo:(NSDictionary*)imageInfo andTheResultCallBlacek:(PAFaceCheckBlock)completion;
@end


/*!
 *  活体检测视图控制器
 */
@interface PAFaceCheck : UIViewController <UIAlertViewDelegate>

/*!
 *  初始化人脸识别设置（APP管理网络则不需要）
 *
 封装为字典形式,如
 NSMutableDictionary *environmentDict = [[NSMutableDictionary alloc]init];
 [environmentDict setValue:@"environment" forKey:@"environment"];
 [environmentDict setValue:@"uuid" forKey:@"uuid123"];
 [environmentDict setValue:@"appKey" forKey:@"1608DF4332FD13C1E053A10B1F0A9095"];
 [environmentDict setValue:@"subSystemId" forKey:@"1608DF4332FD13C1E053A10B1F0A9095"];
 */
+(void)setFaceEnvironmentWithDict:(NSDictionary *)environmentDict;
/*!
 *  活体检测控制器构建方法
 *  @param checkType    设置当前功能 参数见 PACheckType
 *  @param environmentType    设置接入类型 APP管理网络:@"0" SDK管理网络:@"1"
 *  @param card         当前用户身份证号码 与图片上传至服务器 用于后续的对比认证
 *  @param soundContor  语音开关 YES为开启  NO为关闭
 *  @param faceControl  活体开关 YES为开启  NO为关闭
 *  @param quality  高质量开关 YES为开启  NO为关闭
 *  @param simplificationContor  动作精简（原4，精简2） YES为开启  NO为关闭
 *  @param glassesSwitch  眼镜判断 暂时不起作用
 *  @param advertising    广告语 需要直接已字符串形式传入@“广告词”,不需要为空nil，为了保证界面美观，建议两行内
 *  @param faceDelegate 代理  设置代理对象
 */
- (id)initWithPAcheck:(PACheckType)checkType cardId:(NSString *)card andTheInterfaceType:(NSString *)interfaceType andTheSoundContor:(BOOL)soundContor andTheFaceControls:(BOOL)faceControl andQualitySwitch:(BOOL)quality andTheCountdown :(BOOL)countDown andTheSimplificationContor:(BOOL)simplificationContor andTheGlassesSwitch:(BOOL)glassesSwitch andTheAdvertising:(NSString*)advertising delegate:(id <PACheckDelegate>)faceDelegate;
@end





#pragma mark ------------ PAFaceInfo ------------
/*!
 *  SDK返回宿主APP的图片类
 *  通过该类可获取对应的人脸图片及图片质量分值
 */
@interface PAFaceInfo : NSObject

/** 全屏图片*/
@property (readonly) UIImage* image;

/** 人脸图片*/
@property (readonly) UIImage* faceImage;

/** 全屏图片信息 具体参数见 PAFaceImageInfo */
@property (readonly) PAFaceImageInfo imageInfo;

@end






#pragma mark ------------ PAFaceRequest ------------
/*!
 *  人脸识别请求代理
 */
@protocol PAFaceRequestDelegate <NSObject>
@optional

/*!
 *  人脸识别请求代理回调方法
 *
 *  @param infoDict     返回数据字典
 *  目前只有key:     similarity       图片相似度
            宿主APP 参考的阀值 （目前后台设置为万分之一）
            千分之一    0.642574832139
            万分之一    0.696990139599
            十万分之一   0.735864367157
 *  @param error        请求失败报错
 *  @param tag          请求标识
 */
- (void)requestFinish:(NSDictionary *)infoDict error:(NSError *)error tag:(NSInteger)tag;

@end



/*!
 *  人脸识别请求类
 */
@interface PAFaceRequest : NSObject

/*!
 * 1:1人脸识别认证接口
 *  @param delegate             设置代理对象
 *  @param tag                  请求标识
 *  @param userIdType           用户证件类型  1：身份证         2：护照
                                            3：军官证或士兵证  4：港澳通行证
                                            5：PartyNO       9：其他
 *  @param userId               用户证件号码
 *  @param pictureNo            活体照片流水号
 *  @param comparedPicture      比对的照片
 *  @param comparedPictureType  比对的照片类型 1:人脸照 2：证件照
 
 *  PS:该接口会对图片进行加密 比对的照片comparedPicture 请压缩后使用
 */
- (void)requestComparedImageWithDelegate:(id)delegate
                                     tag:(NSInteger)tag
                              userIdType:(NSString *)userIdType
                                  userId:(NSString *)userId
                               pictureNo:(NSString *)pictureNo
                         comparedPicture:(UIImage *)comparedPicture
                     comparedPictureType:(NSString *)comparedPictureType;


/*!
 * 发送请求
 */
- (void)requestStart;

@end

