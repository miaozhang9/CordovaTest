//
//  UIView+JJ.m
//  JJObjCTool
//
//  Created by JJ on 5/13/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "UIView+QH.h"
#import <objc/runtime.h>

@interface UIView (QH)

@property (nonatomic, copy) void (^qh_addSubViewsPressBlock)(id sender);

@end

@implementation UIView (QH)

#pragma mark - getter and setter

- (void (^)(id))qh_addSubViewsPressBlock
{
    return objc_getAssociatedObject(self, @selector(qh_addSubViewsPressBlock));
}

- (void)setqh_addSubViewsPressBlock:(void (^)(id))qh_addSubViewsPressBlock_
{
    objc_setAssociatedObject(self, @selector(qh_addSubViewsPressBlock), qh_addSubViewsPressBlock_, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIView (JJ)

#pragma mark - Frame

- (CGFloat)qh_left {
    return self.frame.origin.x;
}

- (void)setqh_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)qh_top {
    return self.frame.origin.y;
}

- (void)setqh_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)qh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setqh_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)qh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setqh_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)qh_centerX {
    return self.center.x;
}

- (void)setqh_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)qh_centerY {
    return self.center.y;
}

- (void)setqh_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)qh_width {
    return self.frame.size.width;
}

- (void)setqh_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)qh_height {
    return self.frame.size.height;
}

- (void)setqh_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)qh_origin {
    return self.frame.origin;
}

- (void)setqh_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)qh_size {
    return self.frame.size;
}

- (void)setqh_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)qh_screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.qh_left;
    }
    return x;
}

- (CGFloat)qh_screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.qh_top;
    }
    return y;
}

- (CGRect)qh_screenFrame {
    return CGRectMake(self.qh_screenX, self.qh_screenY, self.qh_width, self.qh_height);
}

#pragma mark - Subview

+ (UIView *)qh_topView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.subviews.count > 0)
    {
        return [window.subviews lastObject];
    }
    else
    {
        return window;
    }
}

+ (UIView *)qh_firstView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.subviews.count > 0)
    {
        return [window.subviews objectAtIndex:0];
    }
    else
    {
        return window;
    }
}

- (void)qh_addSubViews:(NSArray *)subViews_
{
    [subViews_ enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [self addSubview:obj];
     }];
}

- (void)qh_addSubViews:(NSArray *)subViews_ target:(id)target_ action:(SEL)action_
{
    [subViews_ enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIButton class]])
         {
             [(UIButton *)obj addTarget:target_ action:action_ forControlEvents:UIControlEventTouchUpInside];
         }
         [self addSubview:obj];
     }];
}

- (void)qh_addSubViews:(NSArray *)subViews_ pressBlock:(void (^)(id sender))pressBlock_
{
    self.qh_addSubViewsPressBlock = pressBlock_;
    
    [self qh_addSubViews:subViews_ target:self action:@selector(qh_addSubViewsHandlePress:)];
}

- (void)qh_addSubViewsHandlePress:(id)sender_
{
    if (self.qh_addSubViewsPressBlock)
    {
        self.qh_addSubViewsPressBlock(sender_);
    }
}

- (void)qh_eachSubview:(void (^)(UIView *subview))block
{
    NSParameterAssert(block != nil);
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        block(subview);
    }];
}

#pragma mark - Screenshot

- (UIImage *)qh_screenCapture:(BOOL)isOpaque
{
    return [self qh_screenCapture:isOpaque margin:UIEdgeInsetsZero];
}

- (UIImage *)qh_screenCapture:(BOOL)isOpaque margin:(UIEdgeInsets)margin
{
    CGRect rect = self.bounds;
    rect.origin.x += margin.left;
    rect.origin.y += margin.top;
    rect.size.width = rect.size.width - margin.left - margin.right;
    rect.size.height = rect.size.height - margin.top - margin.bottom;
    
    UIImage *image = nil;
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, isOpaque, [UIScreen mainScreen].scale);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

#pragma mark - Touch and tap


- (void)qh_whenTapped:(void (^)(void))block
{
    [self qh_whenTouches:1 tapped:1 handler:block];
}

- (void)qh_whenDoubleTapped:(void (^)(void))block
{
    [self qh_whenTouches:2 tapped:1 handler:block];
}

#pragma mark - visible

- (BOOL)qh_isVisible
{
    UIViewController *vc = [self qh_viewController];
    if (!vc)
    {
        return NO;
    }
    
    BOOL isVCLoad = [vc isViewLoaded];
    BOOL haveWindow = (vc.view.window != nil);
    
    return (isVCLoad && haveWindow);
}

#pragma mark - view controller

- (UIViewController *)qh_viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - transform

- (void)qh_scaleWithSX:(CGFloat)sx_ sy:(CGFloat)sy_
{
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformScale(self.transform, sx_, sy_);
}

#pragma mark - line

+ (CGFloat)qh_singleLineWidth
{
    return (1 / [UIScreen mainScreen].scale);
}

+ (CGFloat)qh_singleLineAdjustOffset
{
    return ((1 / [UIScreen mainScreen].scale) / 2);
}

+ (CGFloat)qh_lineWidthWithPixelNumber:(NSInteger)pixelNumber_
{
    return (pixelNumber_ * [self qh_singleLineWidth]);
}

+ (CGFloat)qh_lineAdjustOffsetWithPixelNumber:(NSInteger)pixelNumber_
{
    if (0 == (pixelNumber_ % 2))
    {
        return 0;
    }
    else
    {
        return [self qh_singleLineAdjustOffset];
    }
}

#pragma mark - keyboard

- (void)qh_hideKeyboard{
    [self qh_hideKeyboardOnView:self];
}

- (void)qh_hideKeyboardOnView:(UIView *)view{
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UITextField class]] || [v isKindOfClass:[UITextView class]]) {
            [v resignFirstResponder];
        }
        else{
            [self qh_hideKeyboardOnView:v];
        }
    }
}

@end
