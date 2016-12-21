//
//  QHMASConstraintBuilder.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASConstraintMaker.h"
#import "QHMASViewConstraint.h"
#import "QHMASCompositeConstraint.h"
#import "QHMASConstraint+Private.h"
#import "QHMASViewAttribute.h"
#import "View+QHMASAdditions.h"

@interface QHMASConstraintMaker () <QHMASConstraintDelegate>

@property (nonatomic, weak) QHMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation QHMASConstraintMaker

- (id)initWithView:(QHMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [QHMASViewConstraint installedConstraintsForView:self.view];
        for (QHMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (QHMASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - QHMASConstraintDelegate

- (void)constraint:(QHMASConstraint *)constraint shouldBeReplacedWithConstraint:(QHMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (QHMASConstraint *)constraint:(QHMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    QHMASViewAttribute *viewAttribute = [[QHMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    QHMASViewConstraint *newConstraint = [[QHMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:QHMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        QHMASCompositeConstraint *compositeConstraint = [[QHMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (QHMASConstraint *)addConstraintWithAttributes:(QHMASAttribute)attrs {
    __unused QHMASAttribute anyAttribute = (QHMASAttributeLeft | QHMASAttributeRight | QHMASAttributeTop | QHMASAttributeBottom | QHMASAttributeLeading
                                          | QHMASAttributeTrailing | QHMASAttributeWidth | QHMASAttributeHeight | QHMASAttributeCenterX
                                          | QHMASAttributeCenterY | QHMASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | QHMASAttributeFirstBaseline | QHMASAttributeLastBaseline
#endif
#if TARGET_OS_IPHONE || TARGET_OS_TV
                                          | QHMASAttributeLeftMargin | QHMASAttributeRightMargin | QHMASAttributeTopMargin | QHMASAttributeBottomMargin
                                          | QHMASAttributeLeadingMargin | QHMASAttributeTrailingMargin | QHMASAttributeCenterXWithinMargins
                                          | QHMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & QHMASAttributeLeft) [attributes addObject:self.view.qhMas_left];
    if (attrs & QHMASAttributeRight) [attributes addObject:self.view.qhMas_right];
    if (attrs & QHMASAttributeTop) [attributes addObject:self.view.qhMas_top];
    if (attrs & QHMASAttributeBottom) [attributes addObject:self.view.qhMas_bottom];
    if (attrs & QHMASAttributeLeading) [attributes addObject:self.view.qhMas_leading];
    if (attrs & QHMASAttributeTrailing) [attributes addObject:self.view.qhMas_trailing];
    if (attrs & QHMASAttributeWidth) [attributes addObject:self.view.qhMas_width];
    if (attrs & QHMASAttributeHeight) [attributes addObject:self.view.qhMas_height];
    if (attrs & QHMASAttributeCenterX) [attributes addObject:self.view.qhMas_centerX];
    if (attrs & QHMASAttributeCenterY) [attributes addObject:self.view.qhMas_centerY];
    if (attrs & QHMASAttributeBaseline) [attributes addObject:self.view.qhMas_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & QHMASAttributeFirstBaseline) [attributes addObject:self.view.qhMas_firstBaseline];
    if (attrs & QHMASAttributeLastBaseline) [attributes addObject:self.view.qhMas_lastBaseline];
    
#endif
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    if (attrs & QHMASAttributeLeftMargin) [attributes addObject:self.view.qhMas_leftMargin];
    if (attrs & QHMASAttributeRightMargin) [attributes addObject:self.view.qhMas_rightMargin];
    if (attrs & QHMASAttributeTopMargin) [attributes addObject:self.view.qhMas_topMargin];
    if (attrs & QHMASAttributeBottomMargin) [attributes addObject:self.view.qhMas_bottomMargin];
    if (attrs & QHMASAttributeLeadingMargin) [attributes addObject:self.view.qhMas_leadingMargin];
    if (attrs & QHMASAttributeTrailingMargin) [attributes addObject:self.view.qhMas_trailingMargin];
    if (attrs & QHMASAttributeCenterXWithinMargins) [attributes addObject:self.view.qhMas_centerXWithinMargins];
    if (attrs & QHMASAttributeCenterYWithinMargins) [attributes addObject:self.view.qhMas_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (QHMASViewAttribute *a in attributes) {
        [children addObject:[[QHMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    QHMASCompositeConstraint *constraint = [[QHMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (QHMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (QHMASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (QHMASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (QHMASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (QHMASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (QHMASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (QHMASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (QHMASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (QHMASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (QHMASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (QHMASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (QHMASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (QHMASConstraint *(^)(QHMASAttribute))attributes {
    return ^(QHMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (QHMASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (QHMASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if TARGET_OS_IPHONE || TARGET_OS_TV

- (QHMASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (QHMASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (QHMASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (QHMASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (QHMASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (QHMASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (QHMASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (QHMASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (QHMASConstraint *)edges {
    return [self addConstraintWithAttributes:QHMASAttributeTop | QHMASAttributeLeft | QHMASAttributeRight | QHMASAttributeBottom];
}

- (QHMASConstraint *)size {
    return [self addConstraintWithAttributes:QHMASAttributeWidth | QHMASAttributeHeight];
}

- (QHMASConstraint *)center {
    return [self addConstraintWithAttributes:QHMASAttributeCenterX | QHMASAttributeCenterY];
}

#pragma mark - grouping

- (QHMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        QHMASCompositeConstraint *constraint = [[QHMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
