//
//  SmoothListScrollViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothListScrollViewController.h"

@interface SmoothListScrollViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *contentTextView;
@end

@implementation SmoothListScrollViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //需要在初始化器里面初始化列表视图
        self.scrollView = [[UIScrollView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.scrollView];

    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.userInteractionEnabled = NO;
    NSMutableString *content = [NSMutableString string];
    for (NSInteger index = 1; index < 88; index ++) {
        [content appendFormat:@"第%ld行\n\n", (long)index];
    }
    self.contentTextView.text = content;
    [self.scrollView addSubview:self.contentTextView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*3);
    self.contentTextView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

@end
