import Foundation
import Charts
import SnapKit
import BrightFutures
import Font_Awesome_Swift

class PortfolioView: UIViewController {

    var chart: LineChartKomponent!
    var weeks: [String]!

    var titleLabel: UILabel!

    var totalValueLabel: UILabel!
    var totalReturnLabel: UILabel!
    var todaysReturnLabel: UILabel!
    var returnOnSalesLabel: UILabel!

    var totalValueValue: UILabel!
    var totalReturnValue: UIButton!
    var todaysReturnValue: UIButton!
    var returnOnSalesValue: UILabel!

    var showingTotalPercentage = true
    var showingTodaysPercentage = true

    var controller: TabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        controller = tabBarController as! TabBarController
        view.backgroundColor = UIColor.whiteColor()

        chart = LineChartKomponent(data: gatherChartData(controller.store))
        chart.mode = TimeSpan.MONTH
        chart.refreshData()

        let header = Header()
        .withTitle("Din portefølje", color: UIColor.whiteColor(), font: nil)

        totalValueLabel = createLabel("Nåværende verdi: ")
        totalReturnLabel = createLabel("Avkastning:")
        todaysReturnLabel = createLabel("Dagens endring:")
        returnOnSalesLabel = createLabel("Realisert gevinst:")

        totalValueValue = createLabel("0")
        totalReturnValue = createButton("0")
        todaysReturnValue = createButton("0")
        returnOnSalesValue = createLabel("0")

        totalReturnValue.addTarget(self, action: "switchTotalReturnValue:", forControlEvents: .TouchUpInside)
        todaysReturnValue.addTarget(self, action: "switchTodaysReturnValue:", forControlEvents: .TouchUpInside)

        addChildViewController(chart)
        addChildViewController(header)

        view.addSubview(chart.view)
        view.addSubview(header.view)

        view.addSubview(totalValueLabel)
        view.addSubview(totalReturnLabel)
        view.addSubview(todaysReturnLabel)
        view.addSubview(returnOnSalesLabel)

        view.addSubview(totalValueValue)
        view.addSubview(totalReturnValue)
        view.addSubview(todaysReturnValue)
        view.addSubview(returnOnSalesValue)

        SnapKitHelpers.setConstraints([
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(60)),

                ComponentWrapper(view: totalValueLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(header.view.snp_bottom).marginTop(50)),
                ComponentWrapper(view: totalReturnLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(totalValueLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: todaysReturnLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(totalReturnLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: returnOnSalesLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(todaysReturnLabel.snp_bottom).marginTop(10)),

                ComponentWrapper(view: totalValueValue, rules: ConstraintRules(parentView: view).snapLeft(totalValueLabel.snp_right).marginLeft(50).snapTop(totalValueLabel.snp_top)),
                ComponentWrapper(view: totalReturnValue, rules: ConstraintRules(parentView: view).snapLeft(totalReturnLabel.snp_right).marginLeft(50).snapTop(totalReturnLabel.snp_top)),
                ComponentWrapper(view: todaysReturnValue, rules: ConstraintRules(parentView: view).snapLeft(todaysReturnLabel.snp_right).marginLeft(50).snapTop(todaysReturnLabel.snp_top)),
                ComponentWrapper(view: returnOnSalesValue, rules: ConstraintRules(parentView: view).snapLeft(returnOnSalesLabel.snp_right).marginLeft(50).snapTop(returnOnSalesLabel.snp_top)),

                ComponentWrapper(view: chart.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().marginBottom(80).height(250))
        ])
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setLabels()
        chart.data = gatherChartData(controller.store)
        chart.refreshData()

        controller.store.updateAllStockInfo()
    }


    func switchTotalReturnValue(sender: UIButton) {
        if (showingTotalPercentage) {
            totalReturnValue.setTitle(String(format: "%.2f", Portfolio.valueNow(controller.store)! - Portfolio.rawCost(controller.store.trades)) + " kr", forState: .Normal)
        } else {
            totalReturnValue.setTitle(String(format: "%.2f", (Portfolio.valueNow(controller.store))! / Portfolio.rawCost(controller.store.trades) * 100) + " %", forState: .Normal)
        }
        showingTotalPercentage = !showingTotalPercentage
    }

    func switchTodaysReturnValue(sender: UIButton) {
        if (showingTodaysPercentage) {
            todaysReturnValue.setTitle(String(format: "%.2f", calcTodayChange()) + " kr", forState: .Normal)
        } else {
            todaysReturnValue.setTitle(String(format: "%.2f", calcTodayInc()) + " %", forState: .Normal)
        }
        showingTodaysPercentage = !showingTodaysPercentage
    }

    func gatherChartData(store: Store) -> [StockPriceInstance] {

        if store.trades.count == 0 {
            return []
        }

        let earliestDate = store.trades[0].date
        var dateInc = earliestDate
        let today = NSDate()
        var portfolioData: [StockPriceInstance] = []

        while dateInc.earlierDate(today) == dateInc {
            if let value = Portfolio.valueAtDay(store, date: dateInc) {
                portfolioData.append(StockPriceInstance(date: dateInc, price: value))
            }
            dateInc = NSDate(timeInterval: 86400, sinceDate: dateInc)
        }

        return portfolioData
    }

    func findLastClosingValue(store: Store) -> Double? {
        for i in 1 ... 30 {
            let dayBefore = NSDate(timeIntervalSinceNow: (Double(-i) * 86400.0))
            if let value = Portfolio.valueAtDay(store, date: dayBefore) {
                return value
            }
        }
        return nil
    }


    func setLabels() {
        let valueNow = Portfolio.valueNow(controller.store)!
        let incValue:Double = (Portfolio.valueNow(controller.store))! / Portfolio.rawCost(controller.store.trades) * 100
        let incToday:Double = calcTodayInc()
        let sales = Portfolio.calculateActualSales(controller.store.trades)

        totalValueValue.text = String(format: "%.2f", valueNow) + " kr"
        totalReturnValue.setTitle(String(format: "%.2f", incValue) + " %", forState: .Normal)
        todaysReturnValue.setTitle(String(format: "%.2f", incToday) + " %", forState: .Normal)
        returnOnSalesValue.text = String(format: "%.2f", sales) + " kr"
    }

    func calcTodayInc() -> Double {
        let today = Portfolio.valueAtDay(controller.store, date: NSDate())
        let lastclosing = Portfolio.lastClosingValue(controller.store)

        guard let t = today, l = lastclosing else {
            return 0
        }
        return (t / l) - 1
    }

    func calcTodayChange() -> Double {
        let today = Portfolio.valueAtDay(controller.store, date: NSDate())
        let lastclosing = Portfolio.lastClosingValue(controller.store)

        guard let t = today, l = lastclosing else {
            return 0
        }
        return t - l
    }
}
