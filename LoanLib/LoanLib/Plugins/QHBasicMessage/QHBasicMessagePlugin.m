//
//  QHBasicMessagePlugin.m
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHBasicMessagePlugin.h"
#import "NSMutableDictionary+QH.h"
#import "QHLoanDoorBundle.h"

@implementation QHBasicMessagePlugin

// 获取SDK的版本号
- (void)getSDKVersion:(QHInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:[QHLoanDoorBundle version]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

// 获取BundleID
- (NSString*) getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

// 获取app的名字
- (NSString*) getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

// 获取app版本号
- (NSString*) getLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取app build版本号
- (NSString *)getBundleVersion{
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
}

// 手机别名--用户定义的名称
- (NSString *)getDeviceName
{
    return [[UIDevice currentDevice] name];
}

// 手机系统名称
- (NSString *)getDeviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}

// 手机系统版本
- (NSString *)getDeviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}


// 手机型号
- (NSString *)getDeviceModel
{
    return [[UIDevice currentDevice] model];

}

// 地方型号(国际化区域名称）
- (NSString *)getDeviceLocalModel
{
    return [[UIDevice currentDevice] localizedModel];
}


- (NSDictionary *)getAppMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionary];
    [madic qh_setString:[self getBundleID]  forKey:qhAppBundleID];
    [madic qh_setString:[self getAppName]  forKey:qhAppName];
    [madic qh_setString:[self getLocalAppVersion]  forKey:qhAppVersion];
    [madic qh_setString:[self getBundleVersion]  forKey:qhAppBuildVersion];
    return [madic copy];
}

- (NSDictionary *)getDeviceMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionary];
    [madic qh_setString:[self getDeviceName] forKey:qhDeviceName];
    [madic qh_setString:[self getDeviceSystemName] forKey:qhDeviceSystemName];
    [madic qh_setString:[self getDeviceSystemVersion] forKey:qhDeviceSystemVersion];
    [madic qh_setString:[self getDeviceModel] forKey:qhDeviceModel];
    [madic qh_setString:[self getDeviceLocalModel] forKey:qhDeviceLocalModel];
    return [madic copy];
}

- (NSDictionary *)getAllMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionaryWithDictionary:[self getAppMessage]];
    [madic addEntriesFromDictionary:[self getDeviceMessage]];
    return [madic copy];
}

- (void)searchSomeMessage:(QHInvokedUrlCommand*)command{
    NSString* callbackId = command.callbackId;
    NSArray* options = [command argumentAtIndex:0 withDefault:[NSNull null]];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    if (options.count > 0) {
        NSDictionary *dic = [self getAllMessage];
        NSArray *keys = [dic allKeys];
        for (NSString *str in options) {
            if ([keys containsObject:str]) {
                [mdic setObject:[dic objectForKey:str] forKey:str];
            }
        }
    }
    if (mdic.count == 0) {
        mdic = [@{} mutableCopy];
    }
    
    QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:[mdic copy]];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)getAllMessage:(QHInvokedUrlCommand*)command{
    NSString* callbackId = command.callbackId;
    QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:[self getAllMessage]];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}


@end
