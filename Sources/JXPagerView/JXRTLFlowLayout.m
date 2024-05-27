//
//  JXRTLFlowLayout.m
//
//
//  Created by jx on 2024/5/27.
//

#import "JXRTLFlowLayout.h"

@implementation JXRTLFlowLayout


- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}

@end
