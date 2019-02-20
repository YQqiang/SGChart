//
//  SGViewController.m
//  SGChart
//
//  Created by oxape on 08/23/2018.
//  Copyright (c) 2018 oxape. All rights reserved.
//

#import "SGViewController.h"
#import "SGChart_Example-Swift.h"
#import "LineDemoView.h"

@interface SGViewController ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) LineDemoView *lineView;
@property (nonatomic, strong) BarDemoView *barView;

@end

@implementation SGViewController

#pragma mark - lazy
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 16;
    }
    return _stackView;
}

- (LineDemoView *)lineView {
    if (!_lineView) {
        _lineView = [[LineDemoView alloc] init];
        _lineView.backgroundColor = UIColor.whiteColor;
    }
    return _lineView;
}

- (BarDemoView *)barView {
    if (!_barView) {
        _barView = [[BarDemoView alloc] init];
        _barView.backgroundColor = UIColor.whiteColor;
    }
    return _barView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.view addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:16].active = YES;
    [self.stackView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.stackView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-16].active = YES;
    [self.stackView addArrangedSubview:self.lineView];
    [self.stackView addArrangedSubview:self.barView];
}

@end
