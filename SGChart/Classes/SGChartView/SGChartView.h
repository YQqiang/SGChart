//
//  SGChartView.h
//  operation4ios
//
//  Created by sungrow on 2018/8/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGLegendCollection.h"
#import "SGYAxisUnitView.h"
@class SGChartView, SGCombinedChartView, SGMarkerView;

@protocol SGChartViewDelegate <NSObject>

@optional
- (void)sgChartValueSelected:(SGChartView *)sgChartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight;
- (void)sgChartValueNothingSelected:(SGChartView *)sgChartView;
- (void)sgChartScaled:(SGChartView *)sgChartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;
- (void)sgChartTranslated:(SGChartView *)sgChartView dX:(CGFloat)dX dY:(CGFloat)dY;

@end

@interface SGChartView : UIView

@property (nonatomic, weak) id<SGChartViewDelegate> sgChartViewDelegate;
@property (nonatomic, strong, readonly) SGLegendCollection *legendView;
@property (nonatomic, strong, readonly) SGYAxisUnitView *yUnitView;
@property (nonatomic, strong, readonly) SGCombinedChartView *combinedChartView;
@property (nonatomic, strong, readonly) SGMarkerView *markerView;

- (void)chartHeightConstraint:(CGFloat)height active:(BOOL)active;

@end
