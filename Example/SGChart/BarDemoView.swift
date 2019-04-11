//
//  BarDemoView.swift
//  SGChart_Example
//
//  Created by sungrow on 2019/2/20.
//  Copyright © 2019 oxape. All rights reserved.
//

import UIKit
import SGChart

class BarDemoView: UIView {
    fileprivate private(set) lazy var legendModels = [SGLegendModel]()
    fileprivate private(set) lazy var chartView: SGChartView = {
        let chart = SGChartView()
        chart.combinedChartView.noDataText = "暂无数据"
        chart.combinedChartView.xAxis.resetCustomAxisMin()
        chart.combinedChartView.scaleXEnabled = true
        chart.combinedChartView.xAxis.granularity = 1.0
        chart.combinedChartView.xAxis.centerAxisLabelsEnabled = true
        chart.sgChartViewDelegate = self
        chart.yUnitView.leftUnitLabel.text = "left y axis unit"
        chart.yUnitView.rightUnitLabel.text = "right y axis unit"
        chart.combinedChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (x, axis) -> String in
            if x >= 0 && x <= 11 {
                return String(Int(x + 1))
            }
            return ""
        })
        chart.legendView.didSelectItemAtIndexPath = { [weak self] (index, modelsOption) in
            guard let models = modelsOption else {
                return
            }
            self?.legendModels = models
            self?.updateBarChartView()
            self?.refreshMarkerViewContent(chart.combinedChartView.highlighted.first)
        }
        return chart
    }()
    
    fileprivate lazy var dataSource: [[String: Any]] = {
        var result = [[String: Any]]()
        var ds = [String: Any]()
        ds.updateValue("指标1", forKey: "title")
        ds.updateValue(UIColor.red, forKey: "color")
        ds.updateValue("unit1", forKey: "unit")
        result.append(ds)
        
        ds = [String: Any]()
        ds.updateValue("指标2", forKey: "title")
        ds.updateValue(UIColor.cyan, forKey: "color")
        ds.updateValue("unit2", forKey: "unit")
        result.append(ds)
        
        ds = [String: Any]()
        ds.updateValue("指标3", forKey: "title")
        ds.updateValue(UIColor.blue, forKey: "color")
        ds.updateValue("unit3", forKey: "unit")
        result.append(ds)
        
        ds = [String: Any]()
        ds.updateValue("指标4", forKey: "title")
        ds.updateValue(UIColor.black, forKey: "color")
        ds.updateValue("unit4", forKey: "unit")
        result.append(ds)
        
        ds = [String: Any]()
        ds.updateValue("指标5", forKey: "title")
        ds.updateValue(UIColor.brown, forKey: "color")
        ds.updateValue("unit5", forKey: "unit")
        result.append(ds)
        
        ds = [String: Any]()
        ds.updateValue("指标6", forKey: "title")
        ds.updateValue(UIColor.green, forKey: "color")
        ds.updateValue("unit6", forKey: "unit")
        result.append(ds)
        
        return result.map({ (value) -> [String: Any] in
            var dic = value
            var values = [Int]()
            for i in 0..<12 {
                values.append(Int(arc4random_uniform(30)))
            }
            dic.updateValue(values, forKey: "values")
            return dic
        })
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
}

// MARK: - create view
extension BarDemoView {
    fileprivate func createView() {
        addSubview(chartView)
        chartView.chartHeightConstraint(0, active: false, layout: false)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        chartView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.configChartData()
        }
    }
}

// MARK: - private action
extension BarDemoView {
    
    fileprivate func configChartData() {
        let data = CombinedChartData()
        if let barData = generateBarData() {
            data.barData = barData
            chartView.combinedChartView.data = data
            chartView.combinedChartView.xAxis.axisMaximum = data.xMax + 1.0
        } else {
            chartView.combinedChartView.data = nil
        }
    }
    
    fileprivate func generateBarData() -> BarChartData? {
        var sets = [ChartDataSet]()
        for dic in dataSource {
            guard let values = dic["values"] as? [Int] else {
                return nil
            }
            let title = (dic["title"] as? String) ?? ""
            let color = (dic["color"] as? UIColor) ?? UIColor.white
            var entries = [BarChartDataEntry]()
            for (index, value) in values.enumerated() {
                entries.append(BarChartDataEntry(x: Double(index), y: Double(value)))
            }
            let set = BarChartDataSet(values: entries, label: title)
            set.setColor(color)
            set.drawValuesEnabled = false
            set.axisDependency = .left
            sets.append(set)
        }
        
        var legends = [SGLegendModel]()
        for dataSet in sets {
            let legendModel = SGLegendModel()
            legendModel.chartDataSet = dataSet
            legends.append(legendModel)
        }
        chartView.legendView.config(legends, chartView: chartView.combinedChartView)
        let barData = BarChartData(dataSets: sets)
        let groupSpace = 0.3
        let barSpace = 0.02
        let barWidth = (1 - groupSpace) / Double(barData.dataSets.count) - barSpace
        barData.barWidth = barWidth
        barData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        return dataSource.count > 0 ? barData : nil
    }
    
    fileprivate func updateBarChartView() {
        var arr = [BarChartDataSet]()
        for legendModel in legendModels {
            if !legendModel.isSelected {
                let barSet = legendModel.chartDataSet as! BarChartDataSet
                let ens = barSet.values.map { (entry) -> BarChartDataEntry in
                    entry.x = Double(Int(entry.x))
                    return entry as! BarChartDataEntry
                }
                barSet.values = ens
                arr.append(barSet)
            }
        }
        let barData = BarChartData(dataSets: arr)
        let groupSpace = 0.3
        let barSpace = 0.02
        let barWidth = (1 - groupSpace) / Double(barData.dataSets.count) - barSpace
        barData.barWidth = barWidth
        barData.sgGroupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        let combinedData = CombinedChartData()
        combinedData.barData = barData
        chartView.combinedChartView.data = arr.count > 0 ? combinedData : nil
    }
    
    fileprivate func refreshMarkerViewContent(_ highlight: Highlight?) {
        guard let highlight = highlight else {
            return
        }
        let index = Int(highlight.x)
        let point = CGPoint(x: highlight.xPx, y: highlight.yPx)
        var contents = [String]()
        dataSource.forEach { (dic) in
            let values = dic["values"] as? [Int]
            let title = (dic["title"] as? String) ?? ""
            let unit = (dic["unit"] as? String) ?? ""
            contents.append("\(title): \(values?[index] ?? 0) \(unit)")
        }
        var removeContent = [String]()
        for (index, model) in legendModels.enumerated() {
            if model.isSelected {
                removeContent.append(contents[index])
            }
        }
        contents = contents.filter { (content) -> Bool in
            return !removeContent.contains(content)
        }
        contents.insert("标题 index = \(index)", at: 0)
        if contents.count <= 1 {
            chartView.markerView.isHidden = true
        } else {
            chartView.markerView.isHidden = false
            chartView.markerView.refreshContent(positon: point, content: contents)
        }
    }
}

// MARK: - SGChartViewDelegate
extension BarDemoView: SGChartViewDelegate {
    func sgChartValueNothingSelected(_ sgChartView: SGChartView!) {
    }
    
    func sgChartValueSelected(_ sgChartView: SGChartView!, entry: ChartDataEntry!, highlight: Highlight!) {
        refreshMarkerViewContent(highlight)
    }
    
    func sgChartTranslated(_ sgChartView: SGChartView!, dX: CGFloat, dY: CGFloat) {
    }
    
    func sgChartScaled(_ sgChartView: SGChartView!, scaleX: CGFloat, scaleY: CGFloat) {
    }
}
