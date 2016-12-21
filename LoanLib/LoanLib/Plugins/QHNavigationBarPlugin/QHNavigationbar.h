//
//  QHNavigationbar.h
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHPlugin.h"

@interface QHNavigationbar : QHPlugin

// 设置 Navigationbar 的title
- (void)setNaviBarTitle:(QHInvokedUrlCommand*)command;

// 设置是否现实 Navigationbar
- (void)showNavigationBar:(QHInvokedUrlCommand*)command;

@end
