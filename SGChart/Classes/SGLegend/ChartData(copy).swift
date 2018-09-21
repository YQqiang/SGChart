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

extension BarChartData {
    @objc open func sgGroupBars(fromX: Double, groupSpace: Double, barSpace: Double)
    {
        let setCount = dataSets.count
        if setCount < 1
        {
            print("BarData needs to hold at least 1 BarDataSet to allow grouping.", terminator: "\n")
            return
        }
        
        let max = maxEntryCountSet
        let maxEntryCount = max?.entryCount ?? 0
        
        let groupSpaceWidthHalf = groupSpace / 2.0
        let barSpaceHalf = barSpace / 2.0
        let barWidthHalf = self.barWidth / 2.0
        
        var fromX = fromX
        
        let interval = groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        
        for i in stride(from: 0, to: maxEntryCount, by: 1)
        {
            let start = fromX
            fromX += groupSpaceWidthHalf
            
            (dataSets as? [IBarChartDataSet])?.forEach { set in
                fromX += barSpaceHalf
                fromX += barWidthHalf
                
                if i < set.entryCount
                {
                    if let entry = set.entryForIndex(i)
                    {
                        entry.x = fromX
                    }
                }
                
                fromX += barWidthHalf
                fromX += barSpaceHalf
            }
            
            fromX += groupSpaceWidthHalf
            let end = fromX
            let innerInterval = end - start
            let diff = interval - innerInterval
            
            // correct rounding errors
            if diff > 0 || diff < 0
            {
                fromX += diff
            }
        }
        notifyDataChanged()
    }
}

