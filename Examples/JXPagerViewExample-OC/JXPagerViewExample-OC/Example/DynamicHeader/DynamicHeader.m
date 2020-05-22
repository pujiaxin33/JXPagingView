//
//  DynamicHeader.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/5/22.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "DynamicHeader.h"

@interface DynamicHeader()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation DynamicHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentLabel = [[UILabel alloc] initWithFrame:frame];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.contentLabel];

        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraints:@[top, left, bottom, right]];
    }
    return self;
}

- (void)startRequest {
    self.contentLabel.text = @"    这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本         这是测试文本     ";
    [self.contentLabel sizeToFit];
    if (self.didRequested != nil) {
        //这是用一个多行的label表示内容的动态性。可以根据你的真实情况，可以是UIWebView、UITableView等，只要等接口返回数据并且得到最终内容的高度。通过block回调出去。再调用`[weakSelf.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:0]`方法即可。
        self.didRequested(self.contentLabel.bounds.size.height);
    }

}

@end
