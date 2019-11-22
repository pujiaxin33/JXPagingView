//
//  PagingViewTableHeaderView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "PagingViewTableHeaderView.h"

@interface PagingViewTableHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, strong) UILabel *nickLabel;
@end

@implementation PagingViewTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei.jpg"]];
        self.imageView.clipsToBounds = YES;
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _nickLabel = [[UILabel alloc] init];
        self.nickLabel.font = [UIFont systemFontOfSize:20];
        self.nickLabel.text = @"Monkey·D·路飞";
        self.nickLabel.textColor = [UIColor redColor];
        [self addSubview:self.nickLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageViewFrame = self.bounds;
    self.nickLabel.frame = CGRectMake(10, self.bounds.size.height - 30, 200, 20);
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.imageViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.imageView.frame = frame;
}


@end
