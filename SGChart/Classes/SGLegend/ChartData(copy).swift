//
//  ChartData(copy).swift
//  operation4ios
//
//  Created by sungrow on 2018/8/16.
//  Copyright © 2018年 阳光电源股份有限公司. All rights reserved.
//

import Foundation
import Charts

extension ChartDataSet {
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil;
    }
    
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

@objc
public protocol IUpdateChartDataSG {
    func updateChartDataSG(_ dataSets: [ChartDataSet])
}

extension CombinedChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = lineData {
            chartData.updateSGChartData(form: dataSets)
        }
        
        if let chartData = barData {
            chartData.updateSGChartData(form: dataSets)
        }
        
        if let chartData = scatterData {
            chartData.updateSGChartData(form: dataSets)
        }
        
        if let chartData = candleData {
            chartData.updateSGChartData(form: dataSets)
        }
        
        if let chartData = bubbleData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension LineChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = lineData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension BarChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = barData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension ScatterChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = scatterData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension CandleStickChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = candleData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension BubbleChartView: IUpdateChartDataSG {
    public func updateChartDataSG(_ dataSets: [ChartDataSet]) {
        if let chartData = bubbleData {
            chartData.updateSGChartData(form: dataSets)
        }
    }
}

extension ChartData {
    func updateSGChartData(form dss: [ChartDataSet]) {
        for dataSet1 in dss {
            for dataSet2 in dataSets.reversed() {
                if dataSet1.label == dataSet2.label {
                    removeDataSet(dataSet2)
                    addDataSet(dataSet1)
                }
            }
        }
    }
}

