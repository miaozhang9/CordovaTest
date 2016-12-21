//
//  QHCheckFaceFailViewController.m
//  PANewToapAPP
//
//  Created by wuyp on 16/3/30.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHCheckFaceFailViewController.h"
#import "QHMasonry.h"

static NSString * const kOrangleColor = @"ff6600";
//static int const kButtonSize = 16;
static int const kButtonHeight = 48;

@interface QHCheckFaceFailViewController ()

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *tryAgainButton;

@end

@implementation QHCheckFaceFailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷脸未通过";
    [self setupSubViews];
    [self setupLayout];
}

#pragma mark - event

- (void)tryAgainCheckFace {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init

- (void)setupSubViews {
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.text = @"检测人脸未通过";
    resultLabel.font = [UIFont systemFontOfSize:14];
    resultLabel.textColor = [UIColor qh_colorWithHex:0x9b9b9b];
    [self.view addSubview:resultLabel];
    self.resultLabel = resultLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"请避免拍摄光线过强或过弱";
    descLabel.textColor = resultLabel.textColor;
    descLabel.font = resultLabel.font;
    [self.view addSubview:descLabel];
    self.descLabel = descLabel;
    
    self.tryAgainButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_tryAgainButton setTitle:@"再试一次" forState:UIControlStateNormal];
    [_tryAgainButton addTarget:self action:@selector(tryAgainCheckFace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tryAgainButton];
}

- (void)setupLayout {
    __weak typeof(self) weakSelf = self;
    [_resultLabel qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(169.0 / 2);
        make.centerX.equalTo(weakSelf.view);
        make.height.qhMas_equalTo(14);
    }];
    
    [_descLabel qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.equalTo(_resultLabel.qhMas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.view);
        make.height.qhMas_equalTo(14);
    }];
    
    [_tryAgainButton qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.equalTo(_descLabel.qhMas_bottom).offset(48);
        make.left.equalTo(weakSelf.view).offset(14);
        make.right.equalTo(weakSelf.view).offset(-14);
        make.height.qhMas_equalTo(kButtonHeight);
    }];
}

@end






