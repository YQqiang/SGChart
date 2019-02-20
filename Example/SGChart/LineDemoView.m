//
//  LineDemoView.m
//  SGChart_Example
//
//  Created by sungrow on 2019/2/20.
//  Copyright © 2019 oxape. All rights reserved.
//

#import "LineDemoView.h"
#import <SGChart/SGChartView.h>
#import <SGChart/SGchart-Swift.h>

@interface LineDemoView ()<SGChartViewDelegate>

@property (nonatomic, strong) SGChartView *chartView;
@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *>*dataSource;
@property (nonatomic, strong) NSArray <SGLegendModel *>*legendModels;

@end

@implementation LineDemoView

#pragma mark - lazy
- (SGChartView *)chartView {
    if (!_chartView) {
        _chartView = [[SGChartView alloc] init];
        _chartView.sgChartViewDelegate = self;
        _chartView.combinedChartView.noDataText = @"暂无数据";
        _chartView.combinedChartView.scaleXEnabled = YES;
        _chartView.yUnitView.leftUnitLabel.text = NSLocalizedString(@"left y axis (unit)", @"");
        _chartView.yUnitView.rightUnitLabel.text = NSLocalizedString(@"right y axis (unit)", @"");
        _chartView.combinedChartView.drawOrder = @[@(CombinedChartDrawOrderLine)];
        __weak typeof(self) weakSelf = self;
        [_chartView.legendView setDidSelectItemAtIndexPath:^(NSIndexPath *indexPath, NSArray<SGLegendModel *> *legendModels) {
            weakSelf.legendModels = legendModels;
            [weakSelf refreshMarkerView:weakSelf.chartView.combinedChartView.highlighted.firstObject];
            NSMutableArray <LineChartDataSet *>*dataSets = [NSMutableArray array];
            [legendModels enumerateObjectsUsingBlock:^(SGLegendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.isSelected) {
                    [dataSets addObject:(LineChartDataSet *)obj.chartDataSet];
                }
            }];
            LineChartData *lineData = [[LineChartData alloc]  initWithDataSets:dataSets];
            CombinedChartData *combinedData = [[CombinedChartData alloc] init];
            combinedData.lineData = lineData;
            weakSelf.chartView.combinedChartView.data = dataSets.count > 0 ? combinedData : nil;
        }];
    }
    return _chartView;
}

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

#pragma mark - view
- (void)createView {
    [self addSubview:self.chartView];
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.chartView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.chartView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.chartView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.chartView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.chartView chartHeightConstraint:0 active:NO];
    
    [self configDefaultData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configChartData];
    });
}

- (void)configDefaultData {
    self.dataSource = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.redColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标1"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit1"}];
    [self.dataSource addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.cyanColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标2"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit2"}];
    [self.dataSource addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.blueColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标3"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit3"}];
    [self.dataSource addObject:dic];

    dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.blackColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标4"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit4"}];
    [self.dataSource addObject:dic];

    dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.brownColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标5"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit5"}];
    [self.dataSource addObject:dic];

    dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"color": UIColor.greenColor}];
    [dic addEntriesFromDictionary:@{@"title": @"指标6"}];
    [dic addEntriesFromDictionary:@{@"unit": @"unit6"}];
    [self.dataSource addObject:dic];
    
    [self.dataSource enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *values = [NSMutableArray array];
        for (int i = 0; i < 24 * 60 / 15; i ++) {
            NSNumber *number = [NSNumber numberWithInteger:[self getRandomNumber:idx * 20 + 5 to:(idx + 1) * 20 + 5]];
            [values addObject:number];
        }
        [obj addEntriesFromDictionary:@{@"values": values}];
    }];
}

- (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to {
    return (from + (arc4random() % (to - from + 1)));
}

#pragma mark - action
- (void)configChartData {
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData];
    _chartView.combinedChartView.xAxis.axisMaximum = data.xMax + 0.25;
    _chartView.combinedChartView.data = data;
}

- (LineChartData *)generateLineData {
    LineChartData *d = [[LineChartData alloc] init];
    NSMutableArray <SGLegendModel *>*legends = [NSMutableArray array];
    for (NSMutableDictionary *dic in self.dataSource) {
        NSMutableArray *entries = [[NSMutableArray alloc] init];
        NSArray <NSNumber *>*values = dic[@"values"];
        NSString *title = dic[@"title"];
        UIColor *color = dic[@"color"];
        [values enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [entries addObject:[[ChartDataEntry alloc] initWithX:idx y:obj.doubleValue]];
        }];
        
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:title];
        [set setColor:color];
        set.lineWidth = 1.0;
        set.circleRadius = 0;
        set.circleHoleRadius = 0;
        set.drawValuesEnabled = NO;
        set.mode = LineChartModeLinear;
        set.axisDependency = AxisDependencyLeft;
        [d addDataSet:set];
        
        SGLegendModel *legend = [[SGLegendModel alloc] init];
        legend.chartDataSet = set;
        [legends addObject:legend];
    }
    [self.chartView.legendView config:legends chartView:self.chartView.combinedChartView];
    return d.dataSets.count > 0 ? d : nil;
}

- (void)refreshMarkerView:(ChartHighlight *)highlight {
    if (!highlight) return;
    NSMutableArray <NSString *>*content = [NSMutableArray array];
    NSInteger index = highlight.x;
    CGPoint point = CGPointMake(highlight.xPx, highlight.yPx);
    [self.dataSource enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSNumber *>*values = obj[@"values"];
        NSString *title = obj[@"title"];
        NSString *unit = obj[@"unit"];
        [content addObject:[NSString stringWithFormat:@"%@: %@ (%@)", title, values[index], unit]];
    }];
    NSMutableArray <NSString *>*removeContent = [NSMutableArray array];
    [self.legendModels enumerateObjectsUsingBlock:^(SGLegendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [removeContent addObject:content[idx]];
        }
    }];
    [content removeObjectsInArray:removeContent];
    [content insertObject:[NSString stringWithFormat:@"标题 index = %zd", index] atIndex:0];
    if (content.count <= 1) {
        self.chartView.markerView.hidden = YES;
    } else {
        [self.chartView.markerView refreshContentWithPositon:point content:content];
    }
}

#pragma mark - SGChartViewDelegate
- (void)sgChartTranslated:(SGChartView *)sgChartView dX:(CGFloat)dX dY:(CGFloat)dY {
}

- (void)sgChartScaled:(SGChartView *)sgChartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
}

- (void)sgChartValueSelected:(SGChartView *)sgChartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    [self refreshMarkerView:highlight];
}

- (void)sgChartValueNothingSelected:(SGChartView *)sgChartView {
}

@end
