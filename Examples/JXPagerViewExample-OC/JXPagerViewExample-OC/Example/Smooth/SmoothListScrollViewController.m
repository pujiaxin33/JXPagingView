//
//  SmoothListScrollViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothListScrollViewController.h"
#import "SmoothViewDefines.h"

@interface SmoothListScrollViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) NSInteger count;
@end

@implementation SmoothListScrollViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //需要在初始化器里面初始化列表视图
        self.count = 88;
        self.scrollView = [[UIScrollView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGFloat labelHeight = 40;
    for (NSInteger index = 0; index < self.count; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, index*labelHeight, self.view.bounds.size.width, labelHeight);
        label.text = [NSString stringWithFormat:@"第%ld行", (long)index];
        [self.contentView addSubview:label];
    }
    self.contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.count*labelHeight);
    [self.scrollView addSubview:self.contentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    CGFloat minContentSizeHeight = self.view.bounds.size.height - SmoothViewPinCategoryHeight;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, MAX(minContentSizeHeight, self.contentView.bounds.size.height));
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

@end
