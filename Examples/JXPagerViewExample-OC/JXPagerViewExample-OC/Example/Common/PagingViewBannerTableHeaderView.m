//
//  PagingViewBannerTableHeaderView.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/2/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "PagingViewBannerTableHeaderView.h"

@interface BannerCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = self.contentView.bounds;
}

@end

@interface PagingViewBannerTableHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation PagingViewBannerTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BannerCell *cell = (BannerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"这是第%ld个banner", (long)indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

@end

