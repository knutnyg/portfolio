
import Foundation
import Charts
import UIKit

class LineChartKomponent : UIViewController, ChartViewDelegate{

    var chart:LineChartView!
    var data:[StockPriceInstance]!
    var mode:TimeSpan!

    init(data: [StockPriceInstance]){
        chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"
        chart.legend.enabled = false
        chart.descriptionText = ""
        self.data = []
        super.init(nibName: nil, bundle: nil)
        chart.delegate = self
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
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum TimeSpan: Double {
    case DAY = 100001.0, MONTH = 31.0, HALF_YEAR = 182.0, YEAR = 365.0, ALL = 100000.0
}
