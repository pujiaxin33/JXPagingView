//
//  XIBHeaderViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/4/21.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "XIBHeaderViewController.h"
#import "XIBHeader.h"

@interface XIBHeaderViewController ()
@property (nonatomic, strong) XIBHeader *xibHeader;
@end

@implementation XIBHeaderViewController

- (void)viewDidLoad {
    //因为继承的原因，要提前初始化
    self.xibHeader = (XIBHeader *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XIBHeader class]) owner:nil options:nil] lastObject];

    [super viewDidLoad];


}


- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.xibHeader;
}

@end
