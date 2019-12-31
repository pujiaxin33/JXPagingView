//
//  JXPagerSmoothCollectionFlowLayout.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/31.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXPagerSmoothCollectionFlowLayout.h"

@implementation JXPagerSmoothCollectionFlowLayout

- (CGSize)collectionViewContentSize {
    CGFloat minContentSizeHeight = self.collectionView.bounds.size.height - self.pinCategoryHeight;
    CGSize size = [super collectionViewContentSize];
    if (size.height < minContentSizeHeight) {
        return CGSizeMake(size.width, minContentSizeHeight);
    }
    return size;
}

@end
