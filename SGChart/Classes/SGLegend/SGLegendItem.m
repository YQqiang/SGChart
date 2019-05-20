//
//  SGLegendItem.m
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGLegendItem.h"

@interface SGLegendItem ()

@property (nonatomic, strong) UIView *legendColorLump;
@property (nonatomic, strong) UILabel *legendDescription;

@end

@implementation SGLegendItem

#pragma mark - lazy
- (UIView *)legendColorLump {
    if (!_legendColorLump) {
        _legendColorLump = [[UIView alloc] init];
    }
    return _legendColorLump;
}

- (UILabel *)legendDescription {
    if (!_legendDescription) {
        _legendDescription = [[UILabel alloc] init];
        _legendDescription.numberOfLines = 1;
        _legendDescription.font = [UIFont systemFontOfSize:12];
        _legendDescription.textColor = [UIColor blackColor];
    }
    return _legendDescription;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    [self.contentView addSubview:self.legendColorLump];
    CGFloat colorLumpHW = 8;
    self.legendColorLump.layer.cornerRadius = colorLumpHW * 0.5;
    self.legendColorLump.translatesAutoresizingMaskIntoConstraints = NO;
    [self.legendColorLump.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
    [self.legendColorLump.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.legendColorLump.heightAnchor constraintEqualToConstant:colorLumpHW].active = YES;
    [self.legendColorLump.widthAnchor constraintEqualToConstant:colorLumpHW].active = YES;
    
    [self.contentView addSubview:self.legendDescription];
    self.legendDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [self.legendDescription.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.legendDescription.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
    [self.legendDescription.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [self.legendDescription.leftAnchor constraintEqualToAnchor:self.legendColorLump.rightAnchor constant:4].active = YES;
    
}

- (void)setLegendModel:(SGLegendModel *)legendModel {
    _legendModel = legendModel;
    if (legendModel.legendColor) {
        self.legendColorLump.backgroundColor = legendModel.isSelected ? UIColor.lightGrayColor : legendModel.legendColor;
    }
    
    if (legendModel.legendDesc) {
        self.legendDescription.text = legendModel.legendDesc;
    }
    
    self.legendDescription.textColor = legendModel.isSelected ? UIColor.lightGrayColor : UIColor.blackColor;
}

#pragma mark - action

@end
