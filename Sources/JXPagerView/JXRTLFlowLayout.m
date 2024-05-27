//
//  JXRTLFlowLayout.m
//
//
//  Created by loong on 2024/3/14.
//

#import "JXRTLFlowLayout.h"

@implementation JXRTLFlowLayout


- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}

@end
