
import Foundation
import Charts
import UIKit

class LineChartKomponent : UIViewController, ChartViewDelegate{

    var chart:LineChartView!
    var data:[StockPriceInstance]!
    var mode:TimeSpan!
    var chartMode:ChartMode!

    init(data: [StockPriceInstance], chartmode:ChartMode){
        chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"
        chart.legend.enabled = false
        chart.descriptionText = ""
        self.data = []
        super.init(nibName: nil, bundle: nil)
        chart.delegate = self
        self.chartMode = chartmode
    }

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
        print(dataSetIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(chart)

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: chart, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapBottom().snapTop())
        ]

        SnapKitHelpers.setConstraints(comp)

        refreshData()
    }

    func refreshData() {
        var dataEntries: [ChartDataEntry] = []

        for i in 0 ..< data.count {
            dataEntries.append(ChartDataEntry(value: data[i].price, xIndex: i))
        }

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Verdi")
        dataset.lineWidth = 2.0
        dataset.drawCircleHoleEnabled = false
        dataset.circleRadius = 0.0
        dataset.drawValuesEnabled = false
        dataset.setColor(BLUE_GREY)

        chart.data = LineChartData(xVals: data.map{(pair:StockPriceInstance) in mode == TimeSpan.DAY ? pair.date.timeOfDayShortPrintable() : pair.date.mediumMinusPrintable()}, dataSet: dataset)
        chart.setVisibleXRangeMaximum(CGFloat(mode.rawValue))
        chart.moveViewToX(CGFloat(data.count - Int(mode.rawValue)))
        
        if chartMode == ChartMode.PORTFOLIO {
            
            
            var max1 = 0.0
            if data.count > 0 {
                let minValue =  data.map{(instance:StockPriceInstance) in instance.price}.minElement()
                let maxValue =  data.map{(instance:StockPriceInstance) in instance.price}.maxElement()
                
                max1 = max(maxValue! - 100, -1 * (minValue! - 100))
            }
            
            let fo = NSNumberFormatter()
            fo.numberStyle = .NoStyle
            fo.roundingIncrement = 5
            
            let axis = chart.getAxis(.Left)
//            axis.granularity = 0.05
            
            axis.axisMaxValue = 100 + max1 + 5
            axis.axisMinValue = 100 - max1 - 5
            axis.calcMinMax(min: 0, max: max1 + 100)
            
//            axis.spaceTop = 0.50
//            axis.spaceBottom = 0.50
            
            let line = ChartLimitLine()
            line.limit = 100.0
            line.lineWidth = 0.8
            
            axis.addLimitLine(line)
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.roundingIncrement = 0.05
            
            axis.valueFormatter = formatter
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum TimeSpan: Double {
    case DAY = 100001.0, WEEK = 7.0, MONTH = 31.0, HALF_YEAR = 182.0, YEAR = 365.0, ALL = 100000.0
}

enum ChartMode {
    case PORTFOLIO, STOCK
}
