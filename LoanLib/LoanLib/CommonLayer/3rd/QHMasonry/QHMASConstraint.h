//
//  QHMASConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (QHMASViewConstraint) 
 *  or a group of NSLayoutConstraints (QHMASComposisteConstraint)
 */
@interface QHMASConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (QHMASConstraint * (^)(QHMASEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (QHMASConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (QHMASConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (QHMASConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (QHMASConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (QHMASConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (QHMASConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or QHMASLayoutPriority
 */
- (QHMASConstraint * (^)(QHMASLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to QHMASLayoutPriorityLow
 */
- (QHMASConstraint * (^)())priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to QHMASLayoutPriorityMedium
 */
- (QHMASConstraint * (^)())priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to QHMASLayoutPriorityHigh
 */
- (QHMASConstraint * (^)())priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    QHMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (QHMASConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    QHMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (QHMASConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    QHMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (QHMASConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (QHMASConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (QHMASConstraint *)and;

/**
 *	Creates a new QHMASCompositeConstraint with the called attribute and reciever
 */
- (QHMASConstraint *)left;
- (QHMASConstraint *)top;
- (QHMASConstraint *)right;
- (QHMASConstraint *)bottom;
- (QHMASConstraint *)leading;
- (QHMASConstraint *)trailing;
- (QHMASConstraint *)width;
- (QHMASConstraint *)height;
- (QHMASConstraint *)centerX;
- (QHMASConstraint *)centerY;
- (QHMASConstraint *)baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (QHMASConstraint *)firstBaseline;
- (QHMASConstraint *)lastBaseline;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (QHMASConstraint *)leftMargin;
- (QHMASConstraint *)rightMargin;
- (QHMASConstraint *)topMargin;
- (QHMASConstraint *)bottomMargin;
- (QHMASConstraint *)leadingMargin;
- (QHMASConstraint *)trailingMargin;
- (QHMASConstraint *)centerXWithinMargins;
- (QHMASConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (QHMASConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of qhMas_updateConstraints/qhMas_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(QHMASEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects QHMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) QHMASConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for QHMASConstraint methods.
 *
 *  Defining QHMAS_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define qhMas_equalTo(...)                 equalTo(QHMASBoxValue((__VA_ARGS__)))
#define qhMas_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(QHMASBoxValue((__VA_ARGS__)))
#define qhMas_lessThanOrEqualTo(...)       lessThanOrEqualTo(QHMASBoxValue((__VA_ARGS__)))

#define qhMas_offset(...)                  valueOffset(QHMASBoxValue((__VA_ARGS__)))


#ifdef QHMAS_SHORTHAND_GLOBALS

#define equalTo(...)                     qhMas_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        qhMas_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           qhMas_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      qhMas_offset(__VA_ARGS__)

#endif


@interface QHMASConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (QHMASConstraint * (^)(id attr))qhMas_equalTo;
- (QHMASConstraint * (^)(id attr))qhMas_greaterThanOrEqualTo;
- (QHMASConstraint * (^)(id attr))qhMas_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (QHMASConstraint * (^)(id offset))qhMas_offset;

@end
