//
//  SGLegendModel.m
//  SGChartLegend
//
//  Created by sungrow on 2018/8/15.
//  Copyright © 2018年 sungrow. All rights reserved.
//

#import "SGLegendModel.h"
#import <objc/runtime.h>

@implementation SGLegendModel

- (id)copyWithZone:(NSZone *)zone {
    return [self copySelf];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copySelf];
}

- (instancetype)copySelf {
    SGLegendModel *copy = [[[self class] alloc] init];
    copy.selected = self.isSelected;
    if (self.chartDataSet) {
        copy.chartDataSet = [SGLegendModel copyItem:self.chartDataSet];
    }
    return copy;
}

+ (id)copyItem:(id)item {
    Class class = [item class];
    id copy = [[class alloc] init];
    while (![class isEqual:[NSObject class]]) {
        u_int count;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int i = 0; i<count; i++) {
            const char* char_f = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            if (![[item valueForKey:(NSString *)propertyName] respondsToSelector:@selector(copyWithZone:)]) {
                continue;
            }
            id propertyValue = [[item valueForKey:(NSString *)propertyName] copy];
            if (propertyValue) {
                [copy setValue:propertyValue forKey:propertyName];
            }
        }
        free(properties);
        class = [class superclass];
    }
    return copy;
}

- (void)setChartDataSet:(id<IChartDataSet>)chartDataSet {
    _chartDataSet = chartDataSet;
    if (!self.legendColor && chartDataSet.colors.firstObject) {
        self.legendColor = chartDataSet.colors.firstObject;
    }
    
    if (!self.legendDesc && chartDataSet.label) {
        self.legendDesc = chartDataSet.label;
    }
}

@end
