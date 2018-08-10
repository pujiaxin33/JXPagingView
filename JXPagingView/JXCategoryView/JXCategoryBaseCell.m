//
//  JXCategoryBaseCell.m
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryBaseCell.h"

@interface JXCategoryBaseCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation JXCategoryBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews
{
    self.separatorLine = ({
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        view.backgroundColor = [UIColor colorWithRed:40/255.0 green:44/255.0 blue:61/255.0 alpha:1];
        view;
    });
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat lineWidth = 1;
    CGFloat lineHeight = self.bounds.size.height/3.0;
    self.separatorLine.frame = CGRectMake(self.bounds.size.width-lineWidth, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadDatas:(JXCategoryBaseCellModel *)cellModel {
    if (cellModel.zoomEnabled) {
        self.transform = CGAffineTransformMakeScale(cellModel.zoomScale, cellModel.zoomScale);
    }else {
        self.transform = CGAffineTransformIdentity;
    }
    self.separatorLine.hidden = !cellModel.sepratorLineShowEnabled;
}

@end
