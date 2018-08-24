//
//  SGCombinedChartView.swift
//  operation4ios
//
//  Created by sungrow on 2018/8/20.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

import UIKit
import Charts

public class SGCombinedChartView: CombinedChartView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    private func createView() {
//        self.delegate = nil
        backgroundColor = UIColor.clear
        
        // 图表属性配置
        noDataText = NSLocalizedString("I18N_COMMON_NODATA", comment: "暂无数据")
        chartDescription?.enabled = false
        pinchZoomEnabled = false
        drawBarShadowEnabled = false
        drawGridBackgroundEnabled = false
        drawValueAboveBarEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
        
        // X轴 属性配置
        xAxis.labelPosition = .bottom
        xAxis.spaceMin = 0.0
        xAxis.axisMinimum = 0.0
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        
        // 左侧 Y轴属性配置
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.granularityEnabled = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.setLabelCount(5, force: false)
        
        // 右侧 Y轴属性配置
        rightAxis.labelFont = UIFont.systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = false
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        rightAxis.drawGridLinesEnabled = false
        rightAxis.setLabelCount(5, force: false)
        
        // 图例配置
        legend.enabled = false
    }

}
