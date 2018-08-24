//
//  SGLegendModel.h
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts-Swift.h>

@interface SGLegendModel : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 图例颜色: 若设置了, 则会覆盖 chartDataSet 的颜色
 */
@property (nonatomic, strong) UIColor *legendColor;

/**
 图例描述: 若设置了, 则会覆盖 chartDataSet 的描述
 */
@property (nonatomic, copy) NSString *legendDesc;

/**
 数据集: 包含了 图例颜色和图例描述; 若设置了, 点击图例会隐藏/显示 图表相关数据
 */
@property (nonatomic, strong)  id<IChartDataSet> chartDataSet;

+ (id)copyItem:(id)item;

@end
