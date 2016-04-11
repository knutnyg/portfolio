import Foundation
import UIKit
import SnapKit
import Charts
import BrightFutures
import Font_Awesome_Swift

class StockView: ModalViewController {

    var titleLabel: UILabel!
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
    var chart: LineChartKomponent!

    var stock: Stock!
    var store: Store!

    init(store: Store, stock: Stock) {
        self.store = store
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        height = 540

        var title = "title"

        if let meta = stock.meta {
            if let longName = meta.LONG_NAME {
                title = longName
            }
        } else {
            title = stock.ticker
        }

        let header = Header()
        .withTitle(title, color: WHITE, font: nil)
        .withRightButtonIcon(FAType.FAClose, action: cancel, color: WHITE)

        lastLabel = createLabel("Siste")
//        buyLabel = createLabel("Kjøper")
//        sellLabel = createLabel("Selger")
        incLabel = createLabel("Avk. i dag")
        turnoverLabel = createLabel("Omsatt (MNOK)")
        highLabel = createLabel("Høy")
        lowLabel = createLabel("Lav")
        sellValue = createLabel("")
        buyValue = createLabel("")
        lastValue = createLabel("")
        incValue = createLabel("")
        turnoverValue = createLabel("")
        highValue = createLabel("")
        lowValue = createLabel("")

        newsButton = createButton("nyheter (dismiss)")
        newsButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        timeresolutionSelector = UISegmentedControl(items: ["i dag", "1 mnd", "6 mnd", "1 år", "alt"])
        timeresolutionSelector.addTarget(self, action: "selectorChanged:", forControlEvents: UIControlEvents.ValueChanged)
        timeresolutionSelector.selectedSegmentIndex = 0

        chart = LineChartKomponent(data: gatherChartData(stock, timespan: TimeSpan.DAY))
        chart.mode = TimeSpan.DAY
        chart.refreshData()

        addChildViewController(header)
        addChildViewController(chart)

        view.addSubview(header.view)
        view.addSubview(lastLabel)
        view.addSubview(lastValue)
//        view.addSubview(buyLabel)
//        view.addSubview(buyValue)
//        view.addSubview(sellLabel)
//        view.addSubview(sellValue)
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
        view.addSubview(chart.view)

        let comp: [ComponentWrapper] = [
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(40)),
                ComponentWrapper(view: lastLabel, rules: ConstraintRules(parentView: view).snapTop(header.view.snp_bottom).marginTop(14).centerX(-40).width(150)),
//                ComponentWrapper(view: buyLabel, rules: ConstraintRules(parentView: view).snapTop(lastLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
//                ComponentWrapper(view: sellLabel, rules: ConstraintRules(parentView: view).snapTop(buyLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
                ComponentWrapper(view: incLabel, rules: ConstraintRules(parentView: view).snapTop(lastLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
                ComponentWrapper(view: turnoverLabel, rules: ConstraintRules(parentView: view).snapTop(incLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
                ComponentWrapper(view: lowLabel, rules: ConstraintRules(parentView: view).snapTop(turnoverLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
                ComponentWrapper(view: highLabel, rules: ConstraintRules(parentView: view).snapTop(lowLabel.snp_bottom).marginTop(8).centerX(-40).width(150)),
                ComponentWrapper(view: lastValue, rules: ConstraintRules(parentView: view).snapLeft(lastLabel.snp_right).marginLeft(20).snapTop(lastLabel.snp_top)),
//                ComponentWrapper(view: buyValue, rules: ConstraintRules(parentView: view).snapLeft(buyLabel.snp_right).marginLeft(20).snapTop(buyLabel.snp_top)),
//                ComponentWrapper(view: sellValue, rules: ConstraintRules(parentView: view).snapLeft(sellLabel.snp_right).marginLeft(20).snapTop(sellLabel.snp_top)),
                ComponentWrapper(view: incValue, rules: ConstraintRules(parentView: view).snapLeft(incLabel.snp_right).marginLeft(20).snapTop(incLabel.snp_top)),
                ComponentWrapper(view: turnoverValue, rules: ConstraintRules(parentView: view).snapLeft(turnoverLabel.snp_right).marginLeft(20).snapTop(turnoverLabel.snp_top)),
                ComponentWrapper(view: highValue, rules: ConstraintRules(parentView: view).snapLeft(highLabel.snp_right).marginLeft(20).snapTop(highLabel.snp_top)),
                ComponentWrapper(view: lowValue, rules: ConstraintRules(parentView: view).snapLeft(lowLabel.snp_right).marginLeft(20).snapTop(lowLabel.snp_top)),
                ComponentWrapper(view: newsButton, rules: ConstraintRules(parentView: view).snapBottom(timeresolutionSelector.snp_top).marginBottom(10).snapRight(timeresolutionSelector.snp_right)),
                ComponentWrapper(view: timeresolutionSelector, rules: ConstraintRules(parentView: view).snapBottom(chart.view.snp_top).marginBottom(10).centerX()),
                ComponentWrapper(view: chart.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(10).snapBottom().height(250))
        ]

        SnapKitHelpers.setConstraints(comp)
        let osbResource = OsloBorsResource()

        [osbResource.updateIntradayHistoryForStock(stock),
         osbResource.getHistoryForStock(store, stock: stock),
         osbResource.stockMetaInformation(stock)
        ].sequence().onSuccess {
            (stocks: [Stock]) in
            self.stock = self.stock
            .withIntradayHistory(stocks[0])
            .withHistory(stocks[1].history!)
            .withMeta(stocks[2].meta!)
            self.refreshData(.DAY)
        }.onFailure {
            err in
            print(err)
        }
    }

    func selectorChanged(sender: UISegmentedControl) {
        var mode: TimeSpan = .DAY
        switch (sender.selectedSegmentIndex) {
        case 0: mode = .DAY; break;
        case 1: mode = .MONTH; break;
        case 2: mode = .HALF_YEAR; break;
        case 3: mode = .YEAR; break;
        case 4: mode = .ALL; break;
        default: mode = .DAY; break;
        }
        print("updating")
        refreshData(mode)
    }

    func refreshData(timespan: TimeSpan) {

        if let meta = stock.meta {
            buyValue.text = String(meta.ASK ?? -1)
            sellValue.text = String(meta.BID ?? -1)
            incValue.text = String(format: "%.2f", meta.CHANGE_PCT_SLACK ?? -1) + "%"
            turnoverValue.text = String(format: "%.2f", (meta.TURNOVER_TOTAL ?? -1) / 1000000)
            highValue.text = String(meta.HIGH ?? -1)
            lowValue.text = String(meta.LOW ?? -1)
            lastValue.text = String(meta.LASTNZ_DIV ?? -1)
        }
//
        chart.data = gatherChartData(stock, timespan: timespan)
        chart.mode = timespan
        chart.refreshData()

        setIncBackgroundColor(incValue, stock: stock)

    }

    func filter(data: [StockPriceInstance], mode: TimeSpan) -> [StockPriceInstance] {
        return data.filter({ (spi: StockPriceInstance) in spi.date.laterDate(NSDate(timeIntervalSinceNow: -86400 * mode.rawValue)) == spi.date })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIncBackgroundColor(label:UILabel, stock:Stock) {
        if let meta = stock.meta {
            if meta.CHANGE_PCT_SLACK >= 0 {
                label.backgroundColor = UIColor.greenColor()
            } else {
                label.backgroundColor = UIColor.redColor()
            }
        }
    }

    func gatherChartData(stock: Stock, timespan:TimeSpan) -> [StockPriceInstance]{
        guard let intra = stock.intraDayHistory, full = stock.history else {
                return []
        }
        print(filter(full.history, mode:timespan).count)
        return timespan == TimeSpan.DAY ? intra.history : filter(full.history, mode:timespan)

    }

}
