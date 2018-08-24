//
//  SGLegendCollection.h
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGLegendModel.h"
@protocol IUpdateChartDataSG;

@interface SGLegendCollection : UIView

@property (nonatomic, copy) void (^didSelectItemAtIndexPath)(NSIndexPath *indexPath, NSArray <SGLegendModel *>*dataSource);

- (void)config:(NSArray <SGLegendModel *>*)dataSource chartView:(id<IUpdateChartDataSG, IChartDataSet>)chartView;

@end
