//
//  NSArray+QHMASShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+QHMASAdditions.h"

#ifdef QHMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'qhMas_' prefixes,
 *  only enabled if QHMAS_SHORTHAND is defined
 */
@interface NSArray (QHMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(QHMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(QHMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(QHMASConstraintMaker *make))block;

@end

@implementation NSArray (QHMASShorthandAdditions)

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
