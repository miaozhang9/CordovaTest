//
//  NSArray+QHMASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+QHMASAdditions.h"
#import "View+QHMASAdditions.h"

@implementation NSArray (QHMASAdditions)

- (NSArray *)qhMas_makeConstraints:(void(^)(QHMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (QHMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[QHMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view qhMas_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)qhMas_updateConstraints:(void(^)(QHMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (QHMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[QHMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view qhMas_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)qhMas_remakeConstraints:(void(^)(QHMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (QHMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[QHMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view qhMas_remakeConstraints:block]];
    }
    return constraints;
}

- (void)qhMas_distributeViewsAlongAxis:(QHMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    QHMAS_VIEW *tempSuperView = [self qhMas_commonSuperviewOfViews];
    if (axisType == QHMASAxisTypeHorizontal) {
        QHMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            QHMAS_VIEW *v = self[i];
            [v qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.qhMas_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        QHMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            QHMAS_VIEW *v = self[i];
            [v qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.qhMas_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)qhMas_distributeViewsAlongAxis:(QHMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    QHMAS_VIEW *tempSuperView = [self qhMas_commonSuperviewOfViews];
    if (axisType == QHMASAxisTypeHorizontal) {
        QHMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            QHMAS_VIEW *v = self[i];
            [v qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        QHMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            QHMAS_VIEW *v = self[i];
            [v qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (QHMAS_VIEW *)qhMas_commonSuperviewOfViews
{
    QHMAS_VIEW *commonSuperview = nil;
    QHMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[QHMAS_VIEW class]]) {
            QHMAS_VIEW *view = (QHMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view qhMas_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
