//
//  SmoothListCollectionViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothListCollectionViewController.h"
#import "JXPagerSmoothCollectionFlowLayout.h"
#import "SmoothViewDefines.h"

@interface SmoothListCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SmoothListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = self.bounds;
}
@end

@interface SmoothListCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SmoothListCollectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        JXPagerSmoothCollectionFlowLayout *layout = [[JXPagerSmoothCollectionFlowLayout alloc] init];
        layout.pinCategoryHeight = SmoothViewPinCategoryHeight;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //需要在初始化器里面初始化列表视图
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[SmoothListCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.collectionView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmoothListCollectionCell *cell = (SmoothListCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@:%ld", self.title, indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor((self.view.bounds.size.width - 10)/2), floor((self.view.bounds.size.width - 10)/2));
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (UIView *)listView {
    return self.view;
}


@end


