//
//  QHCreditPassportScanFailView.m
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHScanQRCodeFailView.h"

#define QHScreenWidth [UIScreen mainScreen].bounds.size.width
#define QHScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation QHScanQRCodeFailView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self modifySubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RealNameAuth_fail"]];
    [self addSubview:_imgView];

    self.noteLabel = [[UILabel alloc] init];
    [self addSubview:_noteLabel];
    
    _imgView.frame = CGRectMake((QHScreenWidth-136)/2., 40, 136, 161);
    _noteLabel.frame = CGRectMake(20, 216, QHScreenWidth-40, 20);
}

- (void)modifySubViews
{
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    _noteLabel.font = [UIFont systemFontOfSize:14];
    _noteLabel.textColor = [UIColor colorWithRed:74 green:74 blue:74 alpha:1];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.text = @"扫描到非信用护照二维码";
}

@end
