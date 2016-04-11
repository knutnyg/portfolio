import Foundation
import UIKit
import SnapKit

class TradesView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tradesTable:UITableView!
    var controller: TabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        controller = tabBarController as! TabBarController

        let header = Header()
        .withTitle("Trades", color: UIColor.whiteColor(), font: nil)
        .withRightButtonText("+", action:addTrade)

        tradesTable = UITableView()
        tradesTable.dataSource = self
        tradesTable.delegate = self

        addChildViewController(header)

        view.addSubview(header.view)
        view.addSubview(tradesTable)

        SnapKitHelpers.setConstraints([
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(60)),
                ComponentWrapper(view: tradesTable, rules: ConstraintRules(parentView: view).snapBottom().snapTop(header.view.snp_bottom).horizontalFullWithMargin(0))
        ])
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func addTrade(){
        let newTradeModal = NewTrade(store: controller.store, callback: callback)
        let vc = Modal(vc: newTradeModal, callback: callback)
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: false, completion: nil)
    }

    func callback() {
        print("reloading")
        tradesTable.reloadData()

    }

    private func yearsOfTrades() -> [String]{
        return Array(Set<String>(controller.store.trades.map{$0.date.onlyYear()})).sort({ $0 > $1 })
    }

    private func tradesFromYear(year:String) -> [Trade] {
        return controller.store.trades.filter{$0.date.onlyYear() == year}.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
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

    // --- TABLEVIEW DELEGATES --- //

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

}
