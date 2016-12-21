//
//  QHLightBlackView.h
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHLightBlackView : UIView

@property (nonatomic, strong) UIImageView *lineImageView;

- (instancetype)initWithFrame:(CGRect)frame size:(CGFloat)size;

- (void)startAnimation;
- (void)stopAnimation;

@end
