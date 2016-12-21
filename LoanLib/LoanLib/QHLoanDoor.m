//
//  QHLoanDoor.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHLoanDoor.h"
#import "QHViewController.h"
#import "QHInterceptProtocol.h"
#import "QHLoanDoorBundle.h"

@interface  QHLoanDoor ()

@property (nonatomic, strong) QHViewController *viewController;

@property (nonatomic, copy) void(^shutDownBlock)();

@end

@implementation QHLoanDoor

static QHLoanDoor *door;

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        door = [[self alloc] init];
    });
    return door;
}

- (instancetype)init{
    if (self = [super init]) {
        [NSURLProtocol registerClass:[QHInterceptProtocol class]];
        NSString *version = [QHLoanDoorBundle version];
        NSLog(@"======version:%@========", version);
    }
    return self;
}


- (void)launchDoor:(QHLoanDoorParam *)para
       environment:(QHLoanDoorEnvirenment)envirenment
      successBlock:(void(^)())successBlock
         failBlock:(void(^)(NSError *))failBlock
     shutDownBlock:(void(^)())shutDownBlock{

    self.shutDownBlock = shutDownBlock;

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    UIViewController *rootCtrl = window.rootViewController;
    if (!rootCtrl) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    self.viewController = [[QHViewController alloc] init];
    [self.viewController view];
    self.viewController.navigationController.navigationBar.translucent = NO;
    // self.viewController.title = @"支持插件列表";
    [rootCtrl presentViewController:[[UINavigationController alloc] initWithRootViewController:self.viewController] animated:YES completion:^{
        if (successBlock) {
            successBlock();
        }
    }];
}

- (void)leftBarBtnAction{
    __weak typeof(self) weakself = self;
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        if (weakself.shutDownBlock) {
            weakself.shutDownBlock();
        }
        weakself.shutDownBlock = nil;
        weakself.viewController = nil;
    }];
};


@end


@implementation QHLoanDoorParam

@end
