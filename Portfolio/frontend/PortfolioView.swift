import Foundation
import Charts
import SnapKit
import BrightFutures

class PortfolioView : UIViewController{

    var chart: LineChartView!
    var weeks: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        //get the reference to the shared model
        let tbvc = tabBarController as! MyTabBarController
        let store = tbvc.store

        view.backgroundColor = UIColor.whiteColor()

        let nasStock = Stock(ticker: "NAS.OL")
        let nodStock = Stock(ticker: "NOD.OL")

        let seq = [HistoricalDataFetcher.getHistoricalData(store, stock: nasStock), HistoricalDataFetcher.getHistoricalData(store, stock: nodStock)]

        chart = LineChartView()
        view.addSubview(chart)
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"

        seq.sequence().onSuccess{
            histories in
            nasStock.history = histories[0]
            nodStock.history = histories[1]

            let trades = [
                    Trade(date: NSDate(dateString: "2003-02-22"),
                            price: 49.30,
                            stock: nasStock,
                            count: 60,
                            action: Action.BUY
                    ),
                    Trade(date: NSDate(dateString: "2016-02-25"),
                            price: 43.30,
                            stock: nodStock,
                            count: 40,
                            action: Action.BUY
                    )]

            self.updateChart(trades)
        }

        let button = createButton("to trades")
        button.addTarget(self, action: "toTrades:", forControlEvents: .TouchUpInside)

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: chart, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().height(400))]

        SnapKitHelpers.setConstraints(comp)
    }

    func toTrades(sender:UIButton){

    }

    func updateChart(trades:[Trade]){

        let earliestDate = trades[0].date
        var dateInc = earliestDate
        let today = NSDate()
        var portfolioData:[DateValue] = []

        while dateInc.earlierDate(today) == dateInc {
            if let value = Portfolio.valueAtDay(trades, date: dateInc) {
                portfolioData.append(DateValue(date: dateInc, value: value))
            }
            dateInc = NSDate(timeInterval: 86400, sinceDate: dateInc)
        }

        setChart(portfolioData)
    }

    func setChart(data: [DateValue]) {


        var dataEntries: [ChartDataEntry] = []

        for i in 0..<data.count {
            dataEntries.append(ChartDataEntry(value: data[i].value, xIndex: i))
        }

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Value")
        dataset.lineWidth = 2.0
        dataset.drawCircleHoleEnabled = false
        dataset.drawCubicEnabled = true
        dataset.circleRadius = 0.0
        dataset.drawValuesEnabled = false

        let datas = LineChartData(xVals: data.map{$0.date.shortPrintable()}, dataSets: [dataset])

        chart.data = datas
        chart.setVisibleXRangeMaximum(31)
        chart.moveViewToX(CGFloat(data.count - 31))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
