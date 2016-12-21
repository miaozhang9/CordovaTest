//
//  UIView+JJ.h
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QH)

#pragma mark - Frame

@property (nonatomic) CGFloat qh_top, qh_left, qh_bottom, qh_right;

@property (nonatomic) CGFloat qh_width, qh_height;

@property (nonatomic) CGFloat qh_origin, qh_centerX, qh_centerY;

@property (nonatomic) CGSize qh_size;

// 相对屏幕
@property (nonatomic, readonly) CGFloat qh_screenX;
@property (nonatomic, readonly) CGFloat qh_screenY;
@property (nonatomic, readonly) CGRect qh_screenFrame;
// 所在控制器
@property (nonatomic, readonly) UIViewController *qh_viewController;
#pragma mark - visible
@property (nonatomic, readonly) BOOL qh_isVisible;

#pragma mark - Touch and tap

- (void)qh_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block;

- (void)qh_whenTapped:(void (^)(void))block;
- (void)qh_whenDoubleTapped:(void (^)(void))block;

#pragma mark - Subview

+ (UIView *)qh_topView;
+ (UIView *)qh_firstView;

- (void)qh_addSubViews:(NSArray *)subViews;
- (void)qh_addSubViews:(NSArray *)subViews target:(id)target action:(SEL)action;
- (void)qh_addSubViews:(NSArray *)subViews pressBlock:(void (^)(id sender))pressBlock;

- (void)qh_eachSubview:(void (^)(UIView *subview))block;

#pragma mark - Screenshot

- (UIImage *)qh_screenCapture:(BOOL)isOpaque;
- (UIImage *)qh_screenCapture:(BOOL)isOpaque margin:(UIEdgeInsets)margin;



#pragma mark - transform

- (void)qh_scaleWithSX:(CGFloat)sx sy:(CGFloat)sy;

#pragma mark - line

+ (CGFloat)qh_singleLineWidth;
+ (CGFloat)qh_singleLineAdjustOffset;

+ (CGFloat)qh_lineWidthWithPixelNumber:(NSInteger)pixelNumber;
+ (CGFloat)qh_lineAdjustOffsetWithPixelNumber:(NSInteger)pixelNumber;

#pragma mark - keyboard

- (void)qh_hideKeyboard;

@end
