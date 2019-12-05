![](http://yuqiangcoder.com/assets/postImages/ios/201902/1@2x.png)

### 前言
[Charts](https://github.com/danielgindi/Charts) 是 iOS 平台的图表库；
支持各种图表的绘制，功能十分强大。
但是依旧无法完全满足现有项目的需求，因此扩展了部分简单内容。

### 问题
* [ ] 根据点击的图例，动态显示图表内容 类似[百度Echarts图例功能](https://www.echartsjs.com/gallery/editor.html?c=doc-example/getting-started)

### 完成后的功能演示
1. 折线图示例
    ![](http://yuqiangcoder.com/assets/postImages/ios/201902/lineDemo.gif)

2. 柱状图示例
    ![](http://yuqiangcoder.com/assets/postImages/ios/201902/barDemo.gif)
    
### 功能实现
1. 图例点击
    `Charts` 的 图例(`ChartLegend`)是绘制出来的， 无法精确找到手指触摸的区域范围，判断是点击了哪个图例；`SDK` 中也没提供具体的`API`。
因此舍弃了`SDK`提供的图例功能，通过`CollectionView` 自定义 `FlowLayout`, 实现图例的点击功能。
具体代码查看 `SGLegendCollection`, `SGLegendFlowLayout`。

2. 图例显示
    图例显示需要: 颜色值 和 描述信息， 这些信息图表中也需要且存储在 `IChartDataSet`， 因此图例的数据源持有该数据集即可。
    
    ```
    /**
    数据集: 包含了 图例颜色和图例描述; 若设置了, 点击图例会隐藏/显示 图表相关数据
    */
    @property (nonatomic, strong)  id<IChartDataSet> chartDataSet;
    ```
    
3. 图例和图表的逻辑处理
    1. 点击图例 
        清空数据集
        
        ```
        [model.chartDataSet clear];
        ```
        
        或 从备份数据中取回原有数据
        
        ```
        id<IChartDataSet> originalChartDataSet = self.origianlDataSource[indexPath.row].chartDataSet;
        model.chartDataSet = [SGLegendModel copyItem:originalChartDataSet];
        ```
        
    2. 更新图表
        
        ```
        [self.chartView updateChartDataSG:arr];
        [self.chartView notifyDataSetChanged];
        ```

### 更新图表
1. `Charts` SDK 中并未提供更新图表数据 `API`, 但可以通过给 `ChartData` 添加扩展实现更新。

    ```
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
    ```

2. `Charts` 提供了丰富的图表类型(`CombinedChartView`, `LineChartView`, `BarChartView`, `ScatterChartView`, `CandleStickChartView`, `BubbleChartView`)，为了满足这些图表且使代码更加简洁，因此添加了协议 `IUpdateChartDataSG`

    ```
    @objc
    public protocol IUpdateChartDataSG {
        func updateChartDataSG(_ dataSets: [ChartDataSet])
    }
    ```
    
    也可以使用该协议限制参数的类型。如：
    
    ```
    - (void)config:(NSArray <SGLegendModel *>*)dataSource chartView:(ChartViewBase<IUpdateChartDataSG> *)chartView;
    ```
    
3. 使以上各类图表在扩展中遵循协议，实现协议方法即可, 如下例：
    
    ```
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
    ```
    
    完整代码可查看 `ChartData(copy).swift` 文件。
    
4. 由于仅更新数据集，图表不会重新绘制，上述内容只能 显示/隐藏 数据集
    更新图表需要监听图例的点击，重新给图表塞数据即可。
    
    ```
    __weak typeof(self) weakSelf = self;
   [_chartView.legendView setDidSelectItemAtIndexPath:^(NSIndexPath *indexPath, NSArray<SGLegendModel *> *legendModels) {
       weakSelf.legendModels = legendModels;
       [weakSelf refreshMarkerView:weakSelf.chartView.combinedChartView.highlighted.firstObject];
       NSMutableArray <LineChartDataSet *>*dataSets = [NSMutableArray array];
       [legendModels enumerateObjectsUsingBlock:^(SGLegendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if (!obj.isSelected) {
               [dataSets addObject:(LineChartDataSet *)obj.chartDataSet];
           }
       }];
       LineChartData *lineData = [[LineChartData alloc]  initWithDataSets:dataSets];
       CombinedChartData *combinedData = [[CombinedChartData alloc] init];
       combinedData.lineData = lineData;
       weakSelf.chartView.combinedChartView.data = dataSets.count > 0 ? combinedData : nil;
   }];
    ```
    
5. 分组柱状图
    在更新组合的柱状图时，会存在偏移现象，因为 `SDK` 中在绘制分组的柱状图时会计算柱状图的`x`值，因此在更新前需要恢复数据集的`x`值。
    
    ```
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
    ```
    
    `Charts SDK` 中限制了分组的柱状图数量必须大于2，在尝试了一个柱状图进行分组时，好像也没啥大问题😄, 所以在扩展中新增了一个分组方法（对原方法的修改）。
    
    ```
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
    ```
    
### 其他
关于其他部分，`MarkerView`的实现 和 使用示例请参考`Example`。

博客 地址 [Charts-拓展使用](http://yuqiangcoder.com/2019/02/21/Charts-%E6%8B%93%E5%B1%95%E4%BD%BF%E7%94%A8.html)

