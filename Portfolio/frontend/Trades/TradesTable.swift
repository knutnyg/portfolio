
import Foundation
import UIKit

class TradesTable : UITableViewController {

    var store:Store!

    init(store:Store){
        self.store = store
        super.init(style: .Plain)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name:"StoreChanged", object:nil)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            store.removeTrade(tradeAtIndexPath(indexPath))
            tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")

        let section = indexPath.section
        let trade = tradeAtIndexPath(indexPath)

        cell.textLabel?.text = "\(trade.date.shortPrintable())   \(trade.ticker)   \(trade.price)kr   \(trade.count)stk   \(trade.action)"

        return cell

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return yearsOfTrades()[section]
    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return yearsOfTrades().count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradesFromYear(yearsOfTrades()[section]).count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    private func yearsOfTrades() -> [String]{
        return Array(Set<String>(store.trades.map{$0.date.onlyYear()})).sort({ $0 > $1 })
    }

    private func tradesFromYear(year:String) -> [Trade] {
        return store.trades.filter{$0.date.onlyYear() == year}.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
    }

    public func reload(notification:NSNotification){
        store = notification.object as! Store
        tableView.reloadData()
    }

    private func tradesGroupedByYear() -> [String:[Trade]]{
        var map:[String:[Trade]] = [:]
        for trade in store.trades {
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
