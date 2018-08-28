//
//  SGViewController.m
//  SGChart
//
//  Created by oxape on 08/23/2018.
//  Copyright (c) 2018 oxape. All rights reserved.
//

#import "SGViewController.h"
#import <SGChart/SGChartView.h>
#import <SGChart/SGchart-Swift.h>

@interface SGViewController ()<SGChartViewDelegate>

@property (nonatomic, strong) SGChartView *chartView;

@end

@implementation SGViewController

- (SGChartView *)chartView {
    if (!_chartView) {
        _chartView = [[SGChartView alloc] init];
        _chartView.sgChartViewDelegate = self;
        _chartView.combinedChartView.scaleXEnabled = YES;
        _chartView.yUnitView.leftUnitLabel.text = NSLocalizedString(@"发电量 (度)", @"");
        _chartView.yUnitView.rightUnitLabel.text = NSLocalizedString(@"功率(kw)", @"");
        _chartView.combinedChartView.drawOrder = @[
                                                   @(CombinedChartDrawOrderBar),
                                                   @(CombinedChartDrawOrderLine)
                                                   ];
        __weak typeof(self) weakSelf = self;
        [_chartView.legendView setDidSelectItemAtIndexPath:^(NSIndexPath *indexPath, NSArray<SGLegendModel *> *dataSource) {
            [weakSelf refreshMarkerView:dataSource];
        }];
    }
    return _chartView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.chartView];
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.chartView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.chartView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.chartView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.chartView chartHeightConstraint:0 active:NO];
    [self.chartView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-8].active = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setChartData];
        [self.chartView.legendView layoutIfNeeded];
    });
    
}

- (void)setChartData {
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData];
    data.barData = [self generateBarData];
    _chartView.combinedChartView.xAxis.axisMaximum = data.xMax + 0.25;
    _chartView.combinedChartView.data = data;
    
    NSMutableArray *arr = [NSMutableArray array];
    SGLegendModel *model = [[SGLegendModel alloc] init];
    model.chartDataSet = data.lineData.dataSets.firstObject;
    [arr addObject:model];
    
    model = [[SGLegendModel alloc] init];
    model.chartDataSet = data.barData.dataSets.firstObject;
    [arr addObject:model];
    
    model = [[SGLegendModel alloc] init];
    model.chartDataSet = data.barData.dataSets.lastObject;
    [arr addObject:model];
    
    [self.chartView.legendView config:arr chartView:(id<IChartDataSet, IUpdateChartDataSG>)self.chartView.combinedChartView];
}

- (LineChartData *)generateLineData {
    LineChartData *d = [[LineChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    for (int index = 0; index < 12; index++) {
        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(15) + 5)]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Line DataSet"];
    [set setColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.axisDependency = AxisDependencyLeft;
    [d addDataSet:set];
    return d;
}

- (BarChartData *)generateBarData {
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray<BarChartDataEntry *> *entries2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < 12; index++) {
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:0.0 y:(arc4random_uniform(25) + 25)]];
        [entries2 addObject:[[BarChartDataEntry alloc] initWithX:0.0 yValues:@[@(arc4random_uniform(13) + 12)]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:entries1 label:@"Bar 1"];
    [set1 setColor:[UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f]];
    set1.valueTextColor = [UIColor colorWithRed:60/255.f green:220/255.f blue:78/255.f alpha:1.f];
    set1.valueFont = [UIFont systemFontOfSize:10.f];
    set1.axisDependency = AxisDependencyRight;
    
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries2 label:@"测试"];
    [set2 setColor:[UIColor brownColor]];
    set2.valueTextColor = [UIColor colorWithRed:61/255.f green:165/255.f blue:255/255.f alpha:1.f];
    set2.valueFont = [UIFont systemFontOfSize:10.f];
    set2.axisDependency = AxisDependencyRight;
    
    float groupSpace = 0.06f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    
    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[set1, set2]];
    d.barWidth = barWidth;
    
    // make this BarData object grouped
    [d groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace]; // start at x = 0
    
    return d;
}

#pragma mark - SGChartViewDelegate
- (void)sgChartValueSelected:(SGChartView *)sgChartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    [self refreshMarkerView:nil];
}

- (void)sgChartValueNothingSelected:(SGChartView *)sgChartView {
    
}

- (void)sgChartScaled:(SGChartView *)sgChartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    NSLog(@"----- scaleX = %lf, ----- scaleY = %lf", scaleX, scaleY);
}

- (void)sgChartTranslated:(SGChartView *)sgChartView dX:(CGFloat)dX dY:(CGFloat)dY {
    sgChartView.markerView.hidden = YES;
    NSLog(@"----- dX = %lf, ----- dY = %lf", dX, dY);
}

- (void)refreshMarkerView:(NSArray *)arr {
    NSArray *content = @[@"323423423323423423323423423323423423323423423", @"#$%^^%$$%", @"sdfasdfasdf", @"第四行"];
    if (arr) {
        content = @[@"测试第一行", @"测试第二行"];
    }
    CGPoint point = CGPointMake(self.chartView.combinedChartView.highlighted.firstObject.xPx, self.chartView.combinedChartView.highlighted.firstObject.yPx);
    [self.chartView.markerView refreshContentWithPositon:point content:[content copy]];
}

@end
