//
//  UIView+QHMASShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+QHMASAdditions.h"

#ifdef QHMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'qhMas_' prefixes,
 *  only enabled if QHMAS_SHORTHAND is defined
 */
@interface QHMAS_VIEW (QHMASShorthandAdditions)

@property (nonatomic, strong, readonly) QHMASViewAttribute *left;
@property (nonatomic, strong, readonly) QHMASViewAttribute *top;
@property (nonatomic, strong, readonly) QHMASViewAttribute *right;
@property (nonatomic, strong, readonly) QHMASViewAttribute *bottom;
@property (nonatomic, strong, readonly) QHMASViewAttribute *leading;
@property (nonatomic, strong, readonly) QHMASViewAttribute *trailing;
@property (nonatomic, strong, readonly) QHMASViewAttribute *width;
@property (nonatomic, strong, readonly) QHMASViewAttribute *height;
@property (nonatomic, strong, readonly) QHMASViewAttribute *centerX;
@property (nonatomic, strong, readonly) QHMASViewAttribute *centerY;
@property (nonatomic, strong, readonly) QHMASViewAttribute *baseline;
@property (nonatomic, strong, readonly) QHMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) QHMASViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) QHMASViewAttribute *lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) QHMASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) QHMASViewAttribute *centerYWithinMargins;

#endif

- (NSArray *)makeConstraints:(void(^)(QHMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(QHMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(QHMASConstraintMaker *make))block;

@end

#define QHMAS_ATTR_FORWARD(attr)  \
- (QHMASViewAttribute *)attr {    \
    return [self qhMas_##attr];   \
}

@implementation QHMAS_VIEW (QHMASShorthandAdditions)

QHMAS_ATTR_FORWARD(top);
QHMAS_ATTR_FORWARD(left);
QHMAS_ATTR_FORWARD(bottom);
QHMAS_ATTR_FORWARD(right);
QHMAS_ATTR_FORWARD(leading);
QHMAS_ATTR_FORWARD(trailing);
QHMAS_ATTR_FORWARD(width);
QHMAS_ATTR_FORWARD(height);
QHMAS_ATTR_FORWARD(centerX);
QHMAS_ATTR_FORWARD(centerY);
QHMAS_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

QHMAS_ATTR_FORWARD(firstBaseline);
QHMAS_ATTR_FORWARD(lastBaseline);

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

QHMAS_ATTR_FORWARD(leftMargin);
QHMAS_ATTR_FORWARD(rightMargin);
QHMAS_ATTR_FORWARD(topMargin);
QHMAS_ATTR_FORWARD(bottomMargin);
QHMAS_ATTR_FORWARD(leadingMargin);
QHMAS_ATTR_FORWARD(trailingMargin);
QHMAS_ATTR_FORWARD(centerXWithinMargins);
QHMAS_ATTR_FORWARD(centerYWithinMargins);

#endif

- (QHMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self qhMas_attribute];
}

- (NSArray *)makeConstraints:(void(^)(QHMASConstraintMaker *))block {
    return [self qhMas_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(QHMASConstraintMaker *))block {
    return [self qhMas_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(QHMASConstraintMaker *))block {
    return [self qhMas_remakeConstraints:block];
}

@end

#endif
