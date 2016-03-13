import Foundation
import UIKit
import SnapKit

class TradesView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var addTrade:UIButton!
    var tradesTable:UITableView!

    var controller:MyTabBarController!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name:"StoreChanged", object:nil)

        controller = tabBarController as! MyTabBarController

        addTrade = createButton("Add Trade")
        addTrade.addTarget(self, action: "addTrade:", forControlEvents: .TouchUpInside)

        tradesTable = UITableView()
        tradesTable.dataSource = self
        tradesTable.delegate = self

        view.addSubview(addTrade)
        view.addSubview(tradesTable)

        let components:[ComponentWrapper] = [
            ComponentWrapper(view: addTrade, rules: ConstraintRules(parentView: view).centerX().marginTop(150).snapTop()),
            ComponentWrapper(view: tradesTable, rules: ConstraintRules(parentView: view).snapBottom().snapTop().marginTop(200).snapLeft().snapRight())
        ]

        SnapKitHelpers.setConstraints(components)
    }

    func addTrade(sender:UIButton){
        let vc = NewTrade(store: controller.store)
        presentViewController(vc, animated: false, completion: nil)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            controller.store.removeTrade(tradeAtIndexPath(indexPath))
            tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")

        let section = indexPath.section
        let trade = tradeAtIndexPath(indexPath)

        cell.textLabel?.text = "\(trade.date.shortPrintable())   \(trade.ticker)   \(trade.price)kr   \(trade.count)stk   \(trade.action)"

        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return yearsOfTrades()[section]
    }

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return yearsOfTrades().count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradesFromYear(yearsOfTrades()[section]).count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    private func yearsOfTrades() -> [String]{
        return Array(Set<String>(controller.store.trades.map{$0.date.onlyYear()})).sort({ $0 > $1 })
    }

    private func tradesFromYear(year:String) -> [Trade] {
        return controller.store.trades.filter{$0.date.onlyYear() == year}.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
    }

    public func reload(notification:NSNotification){
        tradesTable.reloadData()
    }

    private func tradesGroupedByYear() -> [String:[Trade]]{
        var map:[String:[Trade]] = [:]
        for trade in controller.store.trades {
            if var arr = map[trade.date.onlyYear()] {
                map[trade.date.onlyYear()] = arr + [trade]
            } else {
                map[trade.date.onlyYear()] = [trade]
            }
        }

        return map
    }

    private func tradeAtIndexPath(indexPath:NSIndexPath) -> Trade {
        return tradesGroupedByYear()[yearsOfTrades()[indexPath.section]]!
        .sort({$0.date.compare($1.date) == NSComparisonResult.OrderedDescending})[indexPath.item]
    }

}
