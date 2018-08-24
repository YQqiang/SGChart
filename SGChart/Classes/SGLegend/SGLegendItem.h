//
//  SGLegendItem.h
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGLegendModel.h"

@interface SGLegendItem : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *legendColorLump;
@property (nonatomic, strong, readonly) UILabel *legendDescription;

@property (nonatomic, strong) SGLegendModel *legendModel;

@end
