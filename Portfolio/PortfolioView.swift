import Foundation
import Charts
import SnapKit

class PortfolioView : UIViewController{

    var chart: LineChartView!
    var weeks: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        let portfolio = Portfolio()
        let trades = [
                Trade(date: NSDate(dateString: "2015-07-01"),
                        price: 297.00,
                        stock: Stock(ticker: "NAS.OL"),
                        count: 16,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 60,
                        action: Action.BUY
                )].sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        chart = LineChartView()
        view.addSubview(chart)
        chart.rightAxis.enabled = false

        let stock = Stock(ticker: "NAS.OL")
        HistoricalDataFetcher().getHistoricalData(stock).onSuccess {
            stockHistory in
            let labels = stockHistory.history.map({ spi in spi.date.shortPrintable() })
            let values: [Double] = stockHistory.history.map({ spi in spi.price })

            self.setChart(labels, values: values)
        }

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: chart, rules: ConstraintRules().horizontalFullWithMargin(view, margin: 10).snapBottom(view.snp_bottom).height(400))]

        SnapKitHelpers.setConstraints(view, components: comp)

        // Do any additional setup after loading the view, typically from a nib.
    }

    func setChart(dataPoints: [String], values: [Double]) {
        chart.noDataText = "You must give me the datas!"

        var dataEntries: [ChartDataEntry] = []

        for i in 0 ..< dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Value")
        dataset.circleRadius = 0.0
        dataset.lineWidth = 2.0


        let data = LineChartData(xVals: dataPoints, dataSets: [dataset])

        chart.data = data
        chart.setVisibleXRangeMaximum(31)
        chart.moveViewToX(CGFloat(values.count - 31))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
