//
//  SGLegendCollection.m
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGLegendCollection.h"
#import "SGLegendItem.h"
#import "SGLegendFlowLayout.h"
#import <SGChart/SGChart-Swift.h>

@interface SGLegendCollection ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSLayoutConstraint *collectionViewHeightConstraint;
@property (nonatomic, strong) NSArray <SGLegendModel *>*dataSource;
@property (nonatomic, strong) NSArray <SGLegendModel *>*origianlDataSource;
@property (nonatomic, strong) id<IUpdateChartDataSG, IChartDataSet> chartView;

@end

@implementation SGLegendCollection

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SGLegendFlowLayout *flowLayout = [[SGLegendFlowLayout alloc] init];
        flowLayout.legendAlignment = SGLegendAlignmentRight;
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.minimumLineSpacing = 8;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(44, 22);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SGLegendItem class] forCellWithReuseIdentifier:NSStringFromClass([SGLegendItem class])];
    }
    return _collectionView;
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
    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.collectionView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.collectionView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    self.collectionViewHeightConstraint = [self.collectionView.heightAnchor constraintEqualToConstant:8];
    self.collectionViewHeightConstraint.active = YES;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height;
}

#pragma mark - action

- (void)setDataSource:(NSArray<SGLegendModel *> *)dataSource {
    _dataSource = dataSource;
    self.origianlDataSource = [[NSArray alloc] initWithArray:dataSource copyItems:YES];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
    [self layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SGLegendItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SGLegendItem class]) forIndexPath:indexPath];
    cell.legendModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SGLegendModel *model = self.dataSource[indexPath.row];
    if (!model.chartDataSet) return;
    model.selected = !model.isSelected;
    if (model.selected) {
        [model.chartDataSet clear];
    } else {
         id<IChartDataSet> originalChartDataSet = self.origianlDataSource[indexPath.row].chartDataSet;
        model.chartDataSet = [SGLegendModel copyItem:originalChartDataSet];
    }
//    [UIView performWithoutAnimation:^{
//        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    }];
    [collectionView reloadData];
    NSArray *tempArr = [[NSArray alloc] initWithArray:self.dataSource copyItems:YES];
    if (self.didSelectItemAtIndexPath) {
        self.didSelectItemAtIndexPath(indexPath, tempArr);
    }
    if (self.chartView) {
        [self updateChartDataSet:tempArr];
    }
}

- (void)updateChartDataSet:(NSArray <SGLegendModel *>*)dataSource {
    NSMutableArray *arr = [NSMutableArray array];
    [dataSource enumerateObjectsUsingBlock:^(SGLegendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.chartDataSet) {
            [arr addObject: obj.chartDataSet];
        }
    }];
    [self.chartView updateChartDataSG:arr];
    [self.chartView notifyDataSetChanged];
}

#pragma mark - public action
- (void)config:(NSArray <SGLegendModel *>*)dataSource chartView:(id<IUpdateChartDataSG, IChartDataSet>)chartView {
    self.chartView = chartView;
    self.dataSource = dataSource;
}

@end
