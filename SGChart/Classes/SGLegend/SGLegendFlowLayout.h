//
//  SGLegendFlowLayout.h
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGLegendFlowLayout : UICollectionViewFlowLayout

- (void)setCommonRowHorizontalAlignment:(NSTextAlignment)comRowAlignment
             lastRowHorizontalAlignment:(NSTextAlignment)lastRowAlignment
                   rowVerticalAlignment:(NSTextAlignment) rowVerticalAlignment;

@end
