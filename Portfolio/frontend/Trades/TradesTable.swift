//
// Created by Knut Nygaard on 07/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit

class TradesTable : UITableViewController {

    var store:Store!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")

        let sortedTrades = store.trades
        .sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        cell.textLabel?.text = sortedTrades[indexPath.item].stock.ticker

        return cell

    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.trades.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
}
