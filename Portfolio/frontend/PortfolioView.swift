import Foundation
import Charts
import SnapKit
import BrightFutures
import Font_Awesome_Swift

class PortfolioView: UIViewController {

    var chart: LineChartKomponent!
    var weeks: [String]!
    var titleLabel: UILabel!
    var valueLabel: UILabel!
    var valueTextLabel: UILabel!
    var totalIncLabel: UILabel!
    var totalIncValue: UILabel!
    var incToday: UILabel!
    var incTodayValue: UILabel!
    var urealisertGevinst: UILabel!
    var urealisertGevinstVerdi: UILabel!
    var realisertGevinst: UILabel!
    var realisertGevinstVerdi: UILabel!


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

        valueLabel = createLabel("Nåværende verdi: ")
        valueTextLabel = createLabel("0")
        totalIncLabel = createLabel("Total endring")
        totalIncValue = createLabel("0 %")
        incToday = createLabel("Dagens endring")
        incTodayValue = createLabel("0")
        urealisertGevinst = createLabel("Urealisert gevinst")
        urealisertGevinstVerdi = createLabel("0")
        realisertGevinst = createLabel("Realisert gevinst")
        realisertGevinstVerdi = createLabel("0")

        addChildViewController(chart)
        addChildViewController(header)

        view.addSubview(chart.view)
        view.addSubview(header.view)
        view.addSubview(valueTextLabel)
        view.addSubview(valueLabel)
        view.addSubview(totalIncLabel)
        view.addSubview(totalIncValue)
        view.addSubview(incToday)
        view.addSubview(incTodayValue)
        view.addSubview(urealisertGevinst)
        view.addSubview(urealisertGevinstVerdi)
        view.addSubview(realisertGevinst)
        view.addSubview(realisertGevinstVerdi)

        SnapKitHelpers.setConstraints([
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(60)),
                ComponentWrapper(view: valueLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(header.view.snp_bottom).marginTop(50)),
                ComponentWrapper(view: totalIncLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(valueLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: incToday, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(totalIncLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: urealisertGevinst, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(incToday.snp_bottom).marginTop(10)),
                ComponentWrapper(view: realisertGevinst, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(urealisertGevinst.snp_bottom).marginTop(10)),
                ComponentWrapper(view: valueTextLabel, rules: ConstraintRules(parentView: view).snapLeft(valueLabel.snp_right).marginLeft(50).snapTop(valueLabel.snp_top)),
                ComponentWrapper(view: totalIncValue, rules: ConstraintRules(parentView: view).snapLeft(totalIncLabel.snp_right).marginLeft(50).snapTop(totalIncLabel.snp_top)),
                ComponentWrapper(view: incTodayValue, rules: ConstraintRules(parentView: view).snapLeft(incToday.snp_right).marginLeft(50).snapTop(incToday.snp_top)),
                ComponentWrapper(view: urealisertGevinstVerdi, rules: ConstraintRules(parentView: view).snapLeft(urealisertGevinst.snp_right).marginLeft(50).snapTop(urealisertGevinst.snp_top)),
                ComponentWrapper(view: realisertGevinstVerdi, rules: ConstraintRules(parentView: view).snapLeft(realisertGevinst.snp_right).marginLeft(50).snapTop(realisertGevinst.snp_top)),
                ComponentWrapper(view: chart.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().marginBottom(80).height(250))
        ])
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setLabels()
        chart.data = gatherChartData(controller.store)
        chart.refreshData()

        controller.store.updateAllStockInfo()
    }

    func setLabels() {
        let valueNow = Portfolio.valueNow(controller.store)!
        let incValue:Double = (Portfolio.valueNow(controller.store))! / Portfolio.rawCost(controller.store.trades) * 100
        let incToday:Double = calcTodayInc()
        let potentialValue = Portfolio.valueNow(controller.store)! - Portfolio.rawCost(controller.store.trades)
        let sales = Portfolio.calculateActualSales(controller.store.trades)

        valueTextLabel.text = "\(valueNow)"
        totalIncValue.text = String(format: "%.2f", incValue) + " %"
        incTodayValue.text = String(format: "%.2f", incToday) + " %"
        urealisertGevinstVerdi.text = "\(potentialValue)"
        realisertGevinstVerdi.text = String(format: "%.2f", sales)
    }

    func calcTodayInc() -> Double {
        let today = Portfolio.valueAtDay(controller.store, date: NSDate())
        let lastclosing = Portfolio.lastClosingValue(controller.store)

        guard let t = today, l = lastclosing else {
            return 0
        }
        return (t / l) - 1
    }
}
