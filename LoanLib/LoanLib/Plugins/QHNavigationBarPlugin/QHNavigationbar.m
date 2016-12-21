//
//  QHNavigationbar.m
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHNavigationbar.h"

@interface QHNavigationbar ()

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSDictionary *pickedContactDictionary;

@end

@implementation QHNavigationbar

- (void)setNaviBarTitle:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    NSString *title = [command argumentAtIndex:0 withDefault:[NSNull null]];
    self.viewController.title = title;
}

- (void)showNavigationBar:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    BOOL isShow = [[command argumentAtIndex:0 withDefault:[NSNull null]] boolValue];
    UINavigationController *naviVC = self.viewController.navigationController;
    [naviVC setNavigationBarHidden:isShow animated:YES];
}

@end
