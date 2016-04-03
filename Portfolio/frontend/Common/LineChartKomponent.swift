
import Foundation
import Charts
import UIKit

class LineChartKomponent : UIViewController{

    var chart:LineChartView!
    var data:[StockPriceInstance]!
    var visibleXRange:CGFloat!

    init(data: [StockPriceInstance]){
        chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"

        self.data = data
        visibleXRange = 0

        super.init(nibName: nil, bundle: nil)
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

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Value")
        dataset.lineWidth = 2.0
        dataset.drawCircleHoleEnabled = false
        dataset.circleRadius = 0.0
        dataset.drawValuesEnabled = false

        chart.data = LineChartData(xVals: data.map{(pair:StockPriceInstance) in pair.date.isInSameDayAs(date: NSDate()) ? pair.date.timeOfDayShortPrintable() : pair.date.shortPrintable()}, dataSet: dataset)
        chart.setVisibleXRangeMaximum(visibleXRange)
        chart.moveViewToX(CGFloat(data.count - Int(visibleXRange)))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
