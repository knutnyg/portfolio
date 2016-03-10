import UIKit
import Charts
import SnapKit

class StockView: UIViewController {

    var chart: LineChartView!
    var weeks: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        let store = Store(dataFile: "store.dat")

        _ = Portfolio()
//        portfolio.trades = [
//                Trade(date: NSDate(dateString: "22.05.2015"),
//                    price: 297.00,
//                    stock: Stock(ticker: "NAS"),
//                    count: 16
//                ),
//                Trade(date: NSDate(dateString: "10.07.2015"),
//                price: 49.30,
//                stock: Stock(ticker: "NOD"),
//                count: 60
//        )]

        chart = LineChartView()
        view.addSubview(chart)
        chart.rightAxis.enabled = false

        let stock = Stock(ticker: "NAS.OL")
        HistoricalDataFetcher().getHistoricalData(store, ticker: stock.ticker).onSuccess {
            stockHistory in
            let labels = stockHistory.history.map({spi in spi.date.shortPrintable()})
            let values:[Double] = stockHistory.history.map({spi in spi.price})

            self.setChart(labels, values: values)
        }

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: chart, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom(view.snp_bottom).height(400))]

        SnapKitHelpers.setConstraints(comp)

        // Do any additional setup after loading the view, typically from a nib.
    }

    func setChart(dataPoints: [String], values: [Double]) {
        chart.noDataText = "You must give me the datas!"

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
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

