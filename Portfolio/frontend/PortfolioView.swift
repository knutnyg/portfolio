import Foundation
import Charts
import SnapKit
import BrightFutures

class PortfolioView: UIViewController {

    var chart: LineChartView!
    var weeks: [String]!
    var titleLabel: UILabel!
    var valueLabel: UILabel!
    var valueTextLabel: UILabel!
    var incLabel: UILabel!
    var incValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "redraw:", name: "StoreChanged", object: nil)

        //get the reference to the shared model
        let tbvc = tabBarController as! MyTabBarController
        view.backgroundColor = UIColor.whiteColor()

        chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"

        titleLabel = createLabel("Din portefølje")
        valueLabel = createLabel("Nåværende verdi: ")
        incLabel = createLabel("Dagens endring: ")
        valueTextLabel = createLabel("22")
        incValue = createLabel("3 %")


        view.addSubview(chart)
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        view.addSubview(incLabel)
        view.addSubview(incValue)
        view.addSubview(valueTextLabel)


        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: titleLabel, rules: ConstraintRules(parentView: view).centerX().snapTop().marginTop(40)),
                ComponentWrapper(view: valueLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(titleLabel.snp_bottom).marginTop(50)),
                ComponentWrapper(view: incLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(valueLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: valueTextLabel, rules: ConstraintRules(parentView: view).snapLeft(valueLabel.snp_right).snapTop(valueLabel.snp_top)),
                ComponentWrapper(view: incValue, rules: ConstraintRules(parentView: view).snapLeft(incLabel.snp_right).snapTop(incLabel.snp_top)),
                ComponentWrapper(view: chart, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().height(400))]

        SnapKitHelpers.setConstraints(comp)
    }

    func updateChart(store: Store) {

        if
                let lastClose = findLastClosingValue(store),
                let currentValue = Portfolio.valueAtDay(store, date: NSDate())
        {
            incValue.text = String(format: "%.2f", ((currentValue - lastClose) / 100)) + "%"
            valueTextLabel.text = "\(currentValue)"
        }

        if store.trades.count == 0 {
            return
        }

        let earliestDate = store.trades[0].date
        var dateInc = earliestDate
        let today = NSDate()
        var portfolioData: [DateValue] = []

        while dateInc.earlierDate(today) == dateInc {
            if let value = Portfolio.valueAtDay(store, date: dateInc) {
                portfolioData.append(DateValue(date: dateInc, value: value))
            }
            dateInc = NSDate(timeInterval: 86400, sinceDate: dateInc)
        }

        setChart(portfolioData)
    }

    func findLastClosingValue(store: Store) -> Double?{
        for i in 1 ... 30 {
            let dayBefore = NSDate(timeIntervalSinceNow: (Double(-i)*86400.0))
            if let value = Portfolio.valueAtDay(store, date: dayBefore) {
                return value
            }
        }
        return nil
    }

    func setChart(data: [DateValue]) {


        var dataEntries: [ChartDataEntry] = []

        for i in 0 ..< data.count {
            dataEntries.append(ChartDataEntry(value: data[i].value, xIndex: i))
        }

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Value")
        dataset.lineWidth = 2.0
        dataset.drawCircleHoleEnabled = false
        dataset.circleRadius = 0.0
        dataset.drawValuesEnabled = false

        let datas = LineChartData(xVals: data.map {
            $0.date.shortPrintable()
        }, dataSets: [dataset])

        chart.data = datas
        chart.setVisibleXRangeMaximum(31)
        chart.moveViewToX(CGFloat(data.count - 31))
    }

    func redraw(notification: NSNotification) {
        updateChart(notification.object as! Store)
        print("received notification of store changed.. redraw!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
