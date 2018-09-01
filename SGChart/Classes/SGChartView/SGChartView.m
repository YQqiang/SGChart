//
//  SGChartView.m
//  operation4ios
//
//  Created by sungrow on 2018/8/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import "SGChartView.h"
#import <SGChart/SGChart-Swift.h>

static const CGFloat ChartViewHeight = 200;

@interface SGChartView ()<ChartViewDelegate>

@property (nonatomic, strong) SGLegendCollection *legendView;
@property (nonatomic, strong) SGYAxisUnitView *yUnitView;
@property (nonatomic, strong) SGCombinedChartView *combinedChartView;
@property (nonatomic, strong) SGMarkerView *markerView;

@property (nonatomic, strong) NSLayoutConstraint *chartHeightConstraint;

@end

@implementation SGChartView

#pragma mark - lazy
- (SGLegendCollection *)legendView {
    if (!_legendView) {
        _legendView = [[SGLegendCollection alloc] init];
    }
    return _legendView;
}

- (SGYAxisUnitView *)yUnitView {
    if (!_yUnitView) {
        _yUnitView = [[SGYAxisUnitView alloc] init];
    }
    return _yUnitView;
}

- (SGCombinedChartView *)combinedChartView {
    if (!_combinedChartView) {
        _combinedChartView = [[SGCombinedChartView alloc] initWithFrame:CGRectZero];
        _combinedChartView.delegate = self;
        [_combinedChartView addSubview:self.markerView];
        self.markerView.hidden = YES;
    }
    return _combinedChartView;
}

- (SGMarkerView *)markerView {
    if (!_markerView) {
        _markerView = [[SGMarkerView alloc] init];
    }
    return _markerView;
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
    [self addSubview:self.legendView];
    self.legendView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.legendView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
    [self.legendView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.legendView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
    [self addSubview:self.yUnitView];
    self.yUnitView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.yUnitView.topAnchor constraintEqualToAnchor:self.legendView.bottomAnchor constant:20].active = YES;
    [self.yUnitView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.yUnitView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
    [self addSubview:self.combinedChartView];
    self.combinedChartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.combinedChartView.topAnchor constraintEqualToAnchor:self.yUnitView.bottomAnchor].active = YES;
    [self.combinedChartView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.combinedChartView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    self.chartHeightConstraint = [self.combinedChartView.heightAnchor constraintEqualToConstant:ChartViewHeight];
    [self chartHeightConstraint:ChartViewHeight active:YES];
    [self.combinedChartView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

#pragma mark - action
- (void)chartHeightConstraint:(CGFloat)height active:(BOOL)active {
    self.chartHeightConstraint.constant = height;
    self.chartHeightConstraint.active = active;
    [self.combinedChartView layoutIfNeeded];
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    self.markerView.hidden = NO;
    if ([self.sgChartViewDelegate conformsToProtocol:@protocol(SGChartViewDelegate)]) {
        if ([self.sgChartViewDelegate respondsToSelector:@selector(sgChartValueSelected:entry:highlight:)]) {
            [self.sgChartViewDelegate sgChartValueSelected:self entry:entry highlight:highlight];
        }
    }
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    self.markerView.hidden = YES;
    if ([self.sgChartViewDelegate conformsToProtocol:@protocol(SGChartViewDelegate)]) {
        if ([self.sgChartViewDelegate respondsToSelector:@selector(sgChartValueNothingSelected:)]) {
            [self.sgChartViewDelegate sgChartValueNothingSelected:self];
        }
    }
}

- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    if ([self.sgChartViewDelegate conformsToProtocol:@protocol(SGChartViewDelegate)]) {
        if ([self.sgChartViewDelegate respondsToSelector:@selector(sgChartScaled:scaleX:scaleY:)]) {
            [self.sgChartViewDelegate sgChartScaled:self scaleX:scaleX scaleY:scaleY];
        }
    }
}

- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    if ([self.sgChartViewDelegate conformsToProtocol:@protocol(SGChartViewDelegate)]) {
        if ([self.sgChartViewDelegate respondsToSelector:@selector(sgChartTranslated:dX:dY:)]) {
            [self.sgChartViewDelegate sgChartTranslated:self dX:dX dY:dY];
        }
    }
}

@end
