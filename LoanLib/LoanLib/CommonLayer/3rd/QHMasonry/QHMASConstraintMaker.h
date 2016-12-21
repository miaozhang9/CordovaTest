//
//  QHMASConstraintBuilder.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASConstraint.h"
#import "QHMASUtilities.h"

typedef NS_OPTIONS(NSInteger, QHMASAttribute) {
    QHMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    QHMASAttributeRight = 1 << NSLayoutAttributeRight,
    QHMASAttributeTop = 1 << NSLayoutAttributeTop,
    QHMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    QHMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    QHMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    QHMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    QHMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    QHMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    QHMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    QHMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    QHMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    QHMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    QHMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    QHMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    QHMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    QHMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    QHMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    QHMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    QHMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    QHMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating QHMASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface QHMASConstraintMaker : NSObject

/**
 *	The following properties return a new QHMASViewConstraint
 *  with the first item set to the makers associated view and the appropriate QHMASViewAttribute
 */
@property (nonatomic, strong, readonly) QHMASConstraint *left;
@property (nonatomic, strong, readonly) QHMASConstraint *top;
@property (nonatomic, strong, readonly) QHMASConstraint *right;
@property (nonatomic, strong, readonly) QHMASConstraint *bottom;
@property (nonatomic, strong, readonly) QHMASConstraint *leading;
@property (nonatomic, strong, readonly) QHMASConstraint *trailing;
@property (nonatomic, strong, readonly) QHMASConstraint *width;
@property (nonatomic, strong, readonly) QHMASConstraint *height;
@property (nonatomic, strong, readonly) QHMASConstraint *centerX;
@property (nonatomic, strong, readonly) QHMASConstraint *centerY;
@property (nonatomic, strong, readonly) QHMASConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) QHMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) QHMASConstraint *lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) QHMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *topMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) QHMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) QHMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new QHMASCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  QHMASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) QHMASConstraint *(^attributes)(QHMASAttribute attrs);

/**
 *	Creates a QHMASCompositeConstraint with type QHMASCompositeConstraintTypeEdges
 *  which generates the appropriate QHMASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) QHMASConstraint *edges;

/**
 *	Creates a QHMASCompositeConstraint with type QHMASCompositeConstraintTypeSize
 *  which generates the appropriate QHMASViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) QHMASConstraint *size;

/**
 *	Creates a QHMASCompositeConstraint with type QHMASCompositeConstraintTypeCenter
 *  which generates the appropriate QHMASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) QHMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any QHMASConstrait are created with this view as the first item
 *
 *	@return	a new QHMASConstraintMaker
 */
- (id)initWithView:(QHMAS_VIEW *)view;

/**
 *	Calls install method on any QHMASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed QHMASConstraints
 */
- (NSArray *)install;

- (QHMASConstraint * (^)(dispatch_block_t))group;

@end
