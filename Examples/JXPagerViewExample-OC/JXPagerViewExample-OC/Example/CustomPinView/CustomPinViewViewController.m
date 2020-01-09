//
//  CustomPinViewViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/1/9.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "CustomPinViewViewController.h"

@interface CustomPinViewViewController ()
@property (nonatomic, strong) UIView *customPinView;
@end

@implementation CustomPinViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //纯粹为了好玩才使用KVC
    [self setValue:@[@"能力", @"爱好", @"队友", @"能力1", @"爱好1", @"队友1", @"能力2", @"爱好2", @"队友2"] forKey:@"titles"];
    self.categoryView.titles = (NSArray <NSString *>*)[self valueForKey:@"titles"];

    //自定义悬浮视图：只需要自己用一个视图包裹一下，把categoryView添加进去，然后再添加其他自定义视图。最后把自定义的容器视图返回给代理方法viewForPinSectionHeaderInPagerView即可。
    //这里仅仅是添加了一个右边的button按钮，其他类似情况都可以按照此思路解决。
    self.customPinView = [[UIView alloc] init];

    CGFloat buttonWidth = 50;
    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width - buttonWidth, JXheightForHeaderInSection);
    [self.customPinView addSubview:self.categoryView];

    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downButton addTarget:self action:@selector(downButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    downButton.frame = CGRectMake(self.categoryView.bounds.size.width, 0, buttonWidth, JXheightForHeaderInSection);
    [self.customPinView addSubview:downButton];
}

- (void)downButtonDidClicked:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"downButton被点击了" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.customPinView;
}

@end
