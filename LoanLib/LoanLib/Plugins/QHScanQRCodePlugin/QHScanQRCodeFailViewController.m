//
//  QHCreditPassportScanFailViewController.m
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHScanQRCodeFailViewController.h"
#import "QHScanQRCodeFailView.h"

@interface QHScanQRCodeFailViewController ()

@end

@implementation QHScanQRCodeFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的信用护照";
    
    QHScanQRCodeFailView *failView = [[QHScanQRCodeFailView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:failView];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
