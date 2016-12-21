//
//  UIView+QHMASAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASUtilities.h"
#import "QHMASConstraintMaker.h"
#import "QHMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating QHMASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface QHMAS_VIEW (QHMASAdditions)

/**
 *	following properties return a new QHMASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_left;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_top;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_right;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_bottom;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_leading;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_trailing;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_width;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_height;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_centerX;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_centerY;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_baseline;
@property (nonatomic, strong, readonly) QHMASViewAttribute *(^qhMas_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_firstBaseline;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_leftMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_rightMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_topMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_bottomMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_leadingMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_trailingMargin;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_centerXWithinMargins;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id qhMas_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)qhMas_closestCommonSuperview:(QHMAS_VIEW *)view;

/**
 *  Creates a QHMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created QHMASConstraints
 */
- (NSArray *)qhMas_makeConstraints:(void(^)(QHMASConstraintMaker *make))block;

/**
 *  Creates a QHMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated QHMASConstraints
 */
- (NSArray *)qhMas_updateConstraints:(void(^)(QHMASConstraintMaker *make))block;

/**
 *  Creates a QHMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated QHMASConstraints
 */
- (NSArray *)qhMas_remakeConstraints:(void(^)(QHMASConstraintMaker *make))block;

@end
