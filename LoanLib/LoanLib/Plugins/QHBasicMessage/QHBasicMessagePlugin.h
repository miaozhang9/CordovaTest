//
//  QHBasicMessagePlugin.h
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHPlugin.h"

@interface QHBasicMessagePlugin : QHPlugin

// 获取SDK的版本号
- (void)getSDKVersion:(QHInvokedUrlCommand *)command;

// 获取某几条信息
- (void)searchSomeMessage:(QHInvokedUrlCommand*)command;

// 获取全部信息
- (void)getAllMessage:(QHInvokedUrlCommand*)command;

@end

#define qhAppBundleID @"bundleID" // BundleID
#define qhAppName @"appName" // app的名字
#define qhAppVersion @"appVersion" // app版本号
#define qhAppBuildVersion @"appBuildVersion" // app build版本号
#define qhDeviceName @"deviceName" // 手机别名--用户定义的名称
#define qhDeviceSystemName @"deviceSystemName" // 手机系统名称
#define qhDeviceSystemVersion @"deviceSystemVersion" // 手机系统版本
#define qhDeviceModel @"deviceModel" // 手机型号
#define qhDeviceLocalModel @"deviceLocalModel" // 地方型号(国际化区域名称）


