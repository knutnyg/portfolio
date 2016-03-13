import Foundation
import UIKit
import SnapKit
import Charts
import BrightFutures

class StockView: UIViewController {

    var lastLabel: UILabel!
    var lastValue: UILabel!
    var buyLabel: UILabel!
    var buyValue: UILabel!
    var sellLabel: UILabel!
    var sellValue: UILabel!
    var incLabel: UILabel!
    var incValue: UILabel!
    var turnoverLabel: UILabel!
    var turnoverValue: UILabel!
    var highLabel: UILabel!
    var lowLabel: UILabel!
    var highValue: UILabel!
    var lowValue: UILabel!

    var newsButton: UIButton!
    var timeresolutionSelector: UISegmentedControl!
    var chart: LineChartView!

    var stock: Stock!
    var store: Store!

    init(store:Store, stock:Stock){
        self.store = store
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        lastLabel = createLabel("Siste")
        buyLabel = createLabel("Kjøper")
        sellLabel = createLabel("Selger")
        incLabel = createLabel("Avk. i dag")
        turnoverLabel = createLabel("Omsatt")
        highLabel = createLabel("Høy")
        lowLabel = createLabel("Lav")
        sellValue = createLabel("207")
        buyValue = createLabel("205")
        lastValue = createLabel("206")
        incValue = createLabel("2 %")
        turnoverValue = createLabel("65M")
        highValue = createLabel("214")
        lowValue = createLabel("204")

        newsButton = createButton("nyheter")
        timeresolutionSelector = UISegmentedControl(items: ["i dag", "1 mnd", "6 mnd", "1 år", "alt"])
        timeresolutionSelector.addTarget(self, action: "selectorChanged:", forControlEvents: UIControlEvents.ValueChanged)
        timeresolutionSelector.selectedSegmentIndex = 0

        chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.noDataText = "You must give me the datas!"

        view.addSubview(lastLabel)
        view.addSubview(lastValue)
        view.addSubview(buyLabel)
        view.addSubview(buyValue)
        view.addSubview(sellLabel)
        view.addSubview(sellValue)
        view.addSubview(incLabel)
        view.addSubview(incValue)
        view.addSubview(turnoverLabel)
        view.addSubview(turnoverValue)
        view.addSubview(highLabel)
        view.addSubview(highValue)
        view.addSubview(lowLabel)
        view.addSubview(lowValue)
        view.addSubview(newsButton)
        view.addSubview(timeresolutionSelector)
        view.addSubview(chart)

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: lastLabel, rules: ConstraintRules(parentView: view).snapTop().marginTop(60).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: buyLabel, rules: ConstraintRules(parentView: view).snapTop(lastLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: sellLabel, rules: ConstraintRules(parentView: view).snapTop(buyLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: incLabel, rules: ConstraintRules(parentView: view).snapTop(sellLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: turnoverLabel, rules: ConstraintRules(parentView: view).snapTop(incLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: lowLabel, rules: ConstraintRules(parentView: view).snapTop(turnoverLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: highLabel, rules: ConstraintRules(parentView: view).snapTop(lowLabel.snp_bottom).marginTop(8).snapLeft().marginLeft(8).width(100)),
                ComponentWrapper(view: lastValue, rules: ConstraintRules(parentView: view).snapLeft(lastLabel.snp_right).marginLeft(20).snapTop(lastLabel.snp_top)),
                ComponentWrapper(view: buyValue, rules: ConstraintRules(parentView: view).snapLeft(buyLabel.snp_right).marginLeft(20).snapTop(buyLabel.snp_top)),
                ComponentWrapper(view: sellValue, rules: ConstraintRules(parentView: view).snapLeft(sellLabel.snp_right).marginLeft(20).snapTop(sellLabel.snp_top)),
                ComponentWrapper(view: incValue, rules: ConstraintRules(parentView: view).snapLeft(incLabel.snp_right).marginLeft(20).snapTop(incLabel.snp_top)),
                ComponentWrapper(view: turnoverValue, rules: ConstraintRules(parentView: view).snapLeft(turnoverLabel.snp_right).marginLeft(20).snapTop(turnoverLabel.snp_top)),
                ComponentWrapper(view: highValue, rules: ConstraintRules(parentView: view).snapLeft(highLabel.snp_right).marginLeft(20).snapTop(highLabel.snp_top)),
                ComponentWrapper(view: lowValue, rules: ConstraintRules(parentView: view).snapLeft(lowLabel.snp_right).marginLeft(20).snapTop(lowLabel.snp_top)),
                ComponentWrapper(view: newsButton, rules: ConstraintRules(parentView: view).snapBottom(timeresolutionSelector.snp_top).marginBottom(10).snapRight(timeresolutionSelector.snp_right)),
                ComponentWrapper(view: timeresolutionSelector, rules: ConstraintRules(parentView: view).snapBottom(chart.snp_top).marginBottom(10).centerX()),
                ComponentWrapper(view: chart, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().height(250))
        ]

        SnapKitHelpers.setConstraints(comp)

        [OsloBorsResource().updateIntradayHistoryForStock(stock),
         OsloBorsResource().getHistoryForStock(store, stock: stock)
        ].sequence().onSuccess{
            (stocks:[Stock]) in
            self.stock = self.stock
            .withIntradayHistory(stocks[0])
            .withHistory(stocks[1].history!)
            self.updateChart(.DAY)
        }
    }

    func selectorChanged(sender: UISegmentedControl){
        var mode:TimeSpan = .DAY
        switch(sender.selectedSegmentIndex) {
            case 0: mode = .DAY; break;
            case 1: mode = .MONTH; break;
            case 2: mode = .HALF_YEAR; break;
            case 3: mode = .YEAR; break;
            case 4: mode = .ALL; break;
            default: mode = .DAY; break;
        }
        print("updating")
        updateChart(mode)
    }

    func updateChart(timespan:TimeSpan) {

        var data: [DateValue] = []
        switch (timespan) {
        case .DAY:
            if let history = stock.intraDayHistory {
                data = try! history.history.map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
            }
        case .MONTH:
            if let history = stock.history {
                data = try! history.history
                .map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
                .filter({(dateValue:DateValue) in dateValue.date.laterDate(NSDate(timeIntervalSinceNow: -86400*31)) == dateValue.date})
            }
        case .HALF_YEAR:
            if let history = stock.history {
                data = try! history.history
                .map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
                .filter({(dateValue:DateValue) in dateValue.date.laterDate(NSDate(timeIntervalSinceNow: -86400*182)) == dateValue.date})
            }
        case .YEAR:
            if let history = stock.history {
                data = try! history.history
                .map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
                .filter({(dateValue:DateValue) in dateValue.date.laterDate(NSDate(timeIntervalSinceNow: -86400*365)) == dateValue.date})
            }
        case .ALL:
            if let history = stock.history {
                data = try! history.history
                .map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
            }
        default:
            if let history = stock.history {
                data = try! history.history
                .map({ (instance: StockPriceInstance) in DateValue(date: instance.date, value: instance.price)})
                .filter({(dateValue:DateValue) in dateValue.date.laterDate(NSDate(timeIntervalSinceNow: -86400*31)) == dateValue.date})
            }
        }

        setChart(data, timespan: timespan)
    }

    func setChart(data: [DateValue], timespan:TimeSpan) {

        var dataEntries: [ChartDataEntry] = []

        for i in 0 ..< data.count {
            dataEntries.append(ChartDataEntry(value: data[i].value, xIndex: i))
        }

        let dataset = LineChartDataSet(yVals: dataEntries, label: "Value")
        dataset.lineWidth = 2.0
        dataset.drawCircleHoleEnabled = false
        dataset.circleRadius = 0.0
        dataset.drawValuesEnabled = false

        switch timespan {
        case .DAY:
            let datas = try! LineChartData(xVals: data.map {(pair:DateValue) in
                pair.date.timeOfDayShortPrintable()
            }, dataSets: [dataset])

            chart.data = datas
            break;
        default:
            let datas = try! LineChartData(xVals: data.map {(pair:DateValue) in
                pair.date.shortPrintable()
            }, dataSets: [dataset])
            chart.data = datas
            break;
        }
    }

    enum TimeSpan {
        case DAY, MONTH, HALF_YEAR, YEAR, ALL
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
