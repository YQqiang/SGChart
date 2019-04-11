//
//  SGLegendFlowLayout.m
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGLegendFlowLayout.h"

@interface SGLegendFlowLayout ()

@end

@implementation SGLegendFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat leftMargin = self.sectionInset.left;
    CGFloat maxY = -1.0f;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (@available(iOS 11.0, *)) {
        } else {
            if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
                continue;
            }
        }
        if (attribute.frame.origin.y >= maxY) {
            leftMargin = self.sectionInset.left;
        }
        attribute.frame = CGRectMake(leftMargin, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);
        
        leftMargin += attribute.frame.size.width + self.minimumInteritemSpacing;
        maxY = MAX(CGRectGetMaxY(attribute.frame), maxY);
    }
    return attributes;
}

@end
