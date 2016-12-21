//
//  QHLightBlackView.m
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHLightBlackView.h"

#define QHScreenWidth [UIScreen mainScreen].bounds.size.width
#define QHScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QHLightBlackView ()

@property (nonatomic, strong) UIImageView *scanRectView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) BOOL isContinue;

@end


@implementation QHLightBlackView

- (instancetype)initWithFrame:(CGRect)frame size:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if (self) {
        _size = size;
        // 保证扫描框的中心位于屏幕的中心
        _originY = (QHScreenHeight-size)/2 - 64;
        [self qh_createSubViews];
        [self qh_scanRectViewWithFrame:CGRectMake(QHScreenWidth/2.0-130, _originY, _size, _size)];
        [self addSubview:self.noteLabel];
    }
    return self;
}

#pragma mark -- public 

- (void)startAnimation
{
    _isContinue = YES;
    _lineImageView.hidden = NO;
    [self qh_animationAction];
}

- (void)stopAnimation
{
    _isContinue = NO;
    _lineImageView.hidden = YES;
}

#pragma mark -- private

- (void)qh_createSubViews
{
    [self qh_createLightGrayViewWithFrame:CGRectMake(0, 0, QHScreenWidth, _originY)];
    [self qh_createLightGrayViewWithFrame:CGRectMake(0, _originY, QHScreenWidth/2.0-_size/2.0, _size)];
    [self qh_createLightGrayViewWithFrame:CGRectMake(0, _originY + _size, QHScreenWidth, QHScreenHeight - _size - _originY)];
    [self qh_createLightGrayViewWithFrame:CGRectMake(QHScreenWidth/2.0+_size/2.0, _originY, QHScreenWidth/2.0-_size/2.0, _size)];
}

-(void)qh_scanRectViewWithFrame:(CGRect)frame
{
    self.scanRectView = [[UIImageView alloc] initWithFrame:frame];
    _scanRectView.image = [UIImage imageNamed:@"CreditPassport_scan_corner"];
    [self addSubview:_scanRectView];
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _size, 2)];
    _lineImageView.image = [UIImage imageNamed:@"CreditPassport_scan_cross"];
    
    [self.scanRectView addSubview:self.lineImageView];
    self.lineImageView.frame = CGRectMake(0, 0, _size, 2);
    
    [self qh_createAroundImageViewWithFrame:CGRectMake(16, 0, _size-32, 1)];
    [self qh_createAroundImageViewWithFrame:CGRectMake(0, 16, 1, _size-32)];
    [self qh_createAroundImageViewWithFrame:CGRectMake(16, _size-1, _size-32, 1)];
    [self qh_createAroundImageViewWithFrame:CGRectMake(_size-1, 16, 1, _size-32)];
}

- (void)qh_createLightGrayViewWithFrame:(CGRect)rect
{
    UIView *grayView = [[UIView alloc] initWithFrame:rect];
    grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:grayView];
}

- (void)qh_createAroundImageViewWithFrame:(CGRect)rect {
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.scanRectView addSubview:lineView];
}

#pragma mark --- timer actions

- (void)qh_animationAction
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        weakSelf.lineImageView.frame = CGRectMake(0, _size, _size, 2);
        } completion:^(BOOL finished) {
            if (!weakSelf.isContinue) {
                weakSelf.lineImageView.hidden = YES;
            }
    }];
}

#pragma mark -- setter and getter

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        self.lineImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"CreditPassport_scan_cross"]];
    }
    return _lineImageView;
}

- (UILabel *)noteLabel
{
    if (!_noteLabel) {
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.scanRectView.frame)+20, QHScreenWidth - 40, 20)];
        _noteLabel.text = @"将信用护照二维码放入框内，即可自动扫描";
        _noteLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        _noteLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noteLabel;
}

@end
