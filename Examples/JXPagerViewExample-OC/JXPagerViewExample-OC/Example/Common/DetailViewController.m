//
//  DetailViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/1/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.titleLabel.text = self.infoString;
    [self.view addSubview:self.titleLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.view.center;
}


@end
