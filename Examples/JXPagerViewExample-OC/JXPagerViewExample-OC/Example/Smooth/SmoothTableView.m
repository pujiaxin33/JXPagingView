//
//  SmoothTableView.m
//  JXPagerViewExample-OC
//
//  Created by tony on 2021/11/20.
//  Copyright © 2021 jiaxin. All rights reserved.
//

#import "SmoothTableView.h"

@implementation SmoothTableView

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, rect.origin.y) animated:animated];
}

@end
