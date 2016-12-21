//
//  UIViewController+QHMASAdditions.m
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+QHMASAdditions.h"

#ifdef QHMAS_VIEW_CONTROLLER

@implementation QHMAS_VIEW_CONTROLLER (QHMASAdditions)

- (QHMASViewAttribute *)qhMas_topLayoutGuide {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (QHMASViewAttribute *)qhMas_topLayoutGuideTop {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (QHMASViewAttribute *)qhMas_topLayoutGuideBottom {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (QHMASViewAttribute *)qhMas_bottomLayoutGuide {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (QHMASViewAttribute *)qhMas_bottomLayoutGuideTop {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (QHMASViewAttribute *)qhMas_bottomLayoutGuideBottom {
    return [[QHMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
