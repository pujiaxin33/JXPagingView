//
//  TestTableViewCell.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()
@property (nonatomic, strong) UIButton *bgButton;
@end

@implementation TestTableViewCell

- (void)dealloc
{
    self.bgButtonClicked = nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    self.bgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.bgButton addTarget:self action:@selector(bgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.bgButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.bgButton.frame = self.contentView.bounds;
}

- (void)bgButtonClicked:(UIButton *)btn {
    self.bgButtonClicked();
}

@end
