//
//  QHMASConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "QHMASViewAttribute.h"
#import "QHMASConstraint.h"
#import "QHMASLayoutConstraint.h"
#import "QHMASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface QHMASViewConstraint : QHMASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) QHMASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) QHMASViewAttribute *secondViewAttribute;

/**
 *	initialises the QHMASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.qhMas_left, view.qhMas_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(QHMASViewAttribute *)firstViewAttribute;

/**
 *  Returns all QHMASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of QHMASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(QHMAS_VIEW *)view;

@end
