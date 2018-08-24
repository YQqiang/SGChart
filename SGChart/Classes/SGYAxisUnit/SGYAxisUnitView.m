//
//  SGYAxisUnitView.m
//  operation4ios
//
//  Created by sungrow on 2018/8/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

#import "SGYAxisUnitView.h"

@interface SGYAxisUnitView ()

@property (nonatomic, strong) UILabel *leftUnitLabel;
@property (nonatomic, strong) UILabel *rightUnitLabel;

@end

@implementation SGYAxisUnitView

#pragma mark - lazy
- (UILabel *)leftUnitLabel {
    if (!_leftUnitLabel) {
        _leftUnitLabel = [[UILabel alloc] init];
        _leftUnitLabel.numberOfLines = 0;
        _leftUnitLabel.textColor = [UIColor darkGrayColor];
        _leftUnitLabel.font = [UIFont systemFontOfSize:13];
        _leftUnitLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftUnitLabel;
}

- (UILabel *)rightUnitLabel {
    if (!_rightUnitLabel) {
        _rightUnitLabel = [[UILabel alloc] init];
        _rightUnitLabel.numberOfLines = 0;
        _rightUnitLabel.textColor = [UIColor darkGrayColor];
        _rightUnitLabel.font = [UIFont systemFontOfSize:13];
        _rightUnitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightUnitLabel;
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
    [self addSubview:self.leftUnitLabel];
    self.leftUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftUnitLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.leftUnitLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:8].active = YES;
    [self.leftUnitLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.leftUnitLabel.rightAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    [self addSubview:self.rightUnitLabel];
    self.rightUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightUnitLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.rightUnitLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.rightUnitLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-8].active = YES;
    [self.rightUnitLabel.leftAnchor constraintEqualToAnchor:self.leftUnitLabel.rightAnchor].active = YES;
}

#pragma mark - action


@end
