//
//  SGLegendFlowLayout.h
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SGLegendAlignmentLeft = 0,
    SGLegendAlignmentCenter,
    SGLegendAlignmentRight,
} SGLegendAlignment;

@interface SGLegendFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) SGLegendAlignment legendAlignment;

@end
