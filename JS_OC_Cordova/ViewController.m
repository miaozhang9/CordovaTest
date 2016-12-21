//
//  ViewController.m
//  JS_OC_Cordova
//
//  Created by Harvey on 16/9/28.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import "ViewController.h"
#import <LoanLib/QHLoanDoor.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
//    self.startPage = @"http://www.baidu.com";
    [super viewDidLoad];

    self.title = @"Native-App";


    NSString *path = [[NSBundle mainBundle] bundlePath];

    NSLog(@"%@", path);

    NSString *homePath = NSHomeDirectory();

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.frame = CGRectMake(0, 0, 300, 50);
    btn.center = self.view.center;
    [btn setTitle:@"启动CordovaSDK" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];


}

- (void)launch{
    [[QHLoanDoor share] launchDoor:nil
               environment:QHLoanDoorEnvirenment_stg
              successBlock:^{
                  //启动成功
              } failBlock:^(NSError *error) {
                  //启动失败
              } shutDownBlock:^{
                  //关闭插件
              }];
}

@end
