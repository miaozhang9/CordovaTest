//
//  UIViewController+QHMASAdditions.h
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "QHMASUtilities.h"
#import "QHMASConstraintMaker.h"
#import "QHMASViewAttribute.h"

#ifdef QHMAS_VIEW_CONTROLLER

@interface QHMAS_VIEW_CONTROLLER (QHMASAdditions)

/**
 *	following properties return a new QHMASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_topLayoutGuide;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_bottomLayoutGuide;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_topLayoutGuideTop;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) QHMASViewAttribute *qhMas_bottomLayoutGuideBottom;


@end

#endif
