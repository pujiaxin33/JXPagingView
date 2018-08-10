//
//  JXCategoryView.m
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryView.h"
#import "JXCategoryCell.h"
#import "JXCategoryCellModel.h"
#import "UIColor+JXAdd.h"

@interface JXCategoryView ()

@end

@implementation JXCategoryView

- (void)initializeDatas
{
    [super initializeDatas];

    _titleColor = [UIColor whiteColor];
    _titleSelectedColor = [UIColor grayColor];
    _titleFontSize = 15.0;
    _titleColorGradientEnabled = NO;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;

    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        JXCategoryCellModel *cellModel = [[JXCategoryCellModel alloc] init];
        cellModel.title = self.titles[i];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

#pragma mark - Override

- (Class)preferredCellClass {
    return [JXCategoryCell class];
}

- (void)preferredRefreshLeftCellModel:(JXCategoryBaseCellModel *)leftCellModel rightCellModel:(JXCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    JXCategoryCellModel *leftModel = (JXCategoryCellModel *)leftCellModel;
    JXCategoryCellModel *rightModel = (JXCategoryCellModel *)rightCellModel;
    //处理颜色渐变
    if (self.titleColorGradientEnabled) {
        if (leftModel.selected) {
            leftModel.titleSelectedColor = [self interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleColor = self.titleColor;
        }else {
            leftModel.titleColor = [self interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleSelectedColor = self.titleSelectedColor;
        }
        if (rightModel.selected) {
            rightModel.titleSelectedColor = [self interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleColor = self.titleColor;
        }else {
            rightModel.titleColor = [self interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleSelectedColor = self.titleSelectedColor;
        }
    }
}

- (CGFloat)preferredCellWidthWithIndex:(NSInteger)index {
    if (self.cellWidth == JXCategoryViewAutomaticDimension) {
        return ceilf([self.titles[index] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.titleFontSize]} context:nil].size.width) + 10;
    }else {
        return self.cellWidth;
    }
}

- (void)preferredRefreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super preferredRefreshCellModel:cellModel index:index];

    JXCategoryCellModel *model = (JXCategoryCellModel *)cellModel;
    model.titleFontSize = self.titleFontSize;
    model.titleColor = self.titleColor;
    model.titleSelectedColor = self.titleSelectedColor;
}

#pragma mark - Private

- (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.red to:toColor.red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.green to:toColor.green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.blue to:toColor.blue percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];

}

@end
