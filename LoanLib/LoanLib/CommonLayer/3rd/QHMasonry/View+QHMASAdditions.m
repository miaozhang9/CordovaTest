//
//  UIView+QHMASAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+QHMASAdditions.h"
#import <objc/runtime.h>

@implementation QHMAS_VIEW (QHMASAdditions)

- (NSArray *)qhMas_makeConstraints:(void(^)(QHMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    QHMASConstraintMaker *constraintMaker = [[QHMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)qhMas_updateConstraints:(void(^)(QHMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    QHMASConstraintMaker *constraintMaker = [[QHMASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)qhMas_remakeConstraints:(void(^)(QHMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    QHMASConstraintMaker *constraintMaker = [[QHMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (QHMASViewAttribute *)qhMas_left {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (QHMASViewAttribute *)qhMas_top {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (QHMASViewAttribute *)qhMas_right {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (QHMASViewAttribute *)qhMas_bottom {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (QHMASViewAttribute *)qhMas_leading {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (QHMASViewAttribute *)qhMas_trailing {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (QHMASViewAttribute *)qhMas_width {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (QHMASViewAttribute *)qhMas_height {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (QHMASViewAttribute *)qhMas_centerX {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (QHMASViewAttribute *)qhMas_centerY {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (QHMASViewAttribute *)qhMas_baseline {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (QHMASViewAttribute *(^)(NSLayoutAttribute))qhMas_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (QHMASViewAttribute *)qhMas_firstBaseline {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (QHMASViewAttribute *)qhMas_lastBaseline {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (QHMASViewAttribute *)qhMas_leftMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (QHMASViewAttribute *)qhMas_rightMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (QHMASViewAttribute *)qhMas_topMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (QHMASViewAttribute *)qhMas_bottomMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (QHMASViewAttribute *)qhMas_leadingMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (QHMASViewAttribute *)qhMas_trailingMargin {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (QHMASViewAttribute *)qhMas_centerXWithinMargins {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (QHMASViewAttribute *)qhMas_centerYWithinMargins {
    return [[QHMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)qhMas_key {
    return objc_getAssociatedObject(self, @selector(qhMas_key));
}

- (void)setMas_key:(id)key {
    objc_setAssociatedObject(self, @selector(qhMas_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)qhMas_closestCommonSuperview:(QHMAS_VIEW *)view {
    QHMAS_VIEW *closestCommonSuperview = nil;

    QHMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        QHMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
