//
//  QHMASCompositeConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASConstraint.h"
#import "QHMASUtilities.h"

/**
 *	A group of QHMASConstraint objects
 */
@interface QHMASCompositeConstraint : QHMASConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child QHMASConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
