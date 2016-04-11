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
    var incLabel: UILabel!
    var incValue: UILabel!

    var controller:TabBarController!

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
        incLabel = createLabel("Dagens endring: ")
        valueTextLabel = createLabel("22")
        incValue = createLabel("3 %")

        addChildViewController(chart)
        addChildViewController(header)

        view.addSubview(chart.view)
        view.addSubview(header.view)
        view.addSubview(valueLabel)
        view.addSubview(incLabel)
        view.addSubview(incValue)
        view.addSubview(valueTextLabel)

        SnapKitHelpers.setConstraints([
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(60)),
                ComponentWrapper(view: valueLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(header.view.snp_bottom).marginTop(50)),
                ComponentWrapper(view: incLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(20).width(150).snapTop(valueLabel.snp_bottom).marginTop(10)),
                ComponentWrapper(view: valueTextLabel, rules: ConstraintRules(parentView: view).snapLeft(valueLabel.snp_right).snapTop(valueLabel.snp_top)),
                ComponentWrapper(view: incValue, rules: ConstraintRules(parentView: view).snapLeft(incLabel.snp_right).snapTop(incLabel.snp_top)),
                ComponentWrapper(view: chart.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().marginBottom(80).height(350))
        ])
    }



    func gatherChartData(store: Store) -> [StockPriceInstance]{

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

    func findLastClosingValue(store: Store) -> Double?{
        for i in 1 ... 30 {
            let dayBefore = NSDate(timeIntervalSinceNow: (Double(-i)*86400.0))
            if let value = Portfolio.valueAtDay(store, date: dayBefore) {
                return value
            }
        }
        return nil
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        chart.data = gatherChartData(controller.store)
        chart.refreshData()

        controller.store.updateAllStockInfo()
    }
}
