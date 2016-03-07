import Foundation
import UIKit
import SnapKit

class TradesView: UIViewController {

    var addTrade:UIButton!
    var tradesTable:TradesTable!

    var controller:MyTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        controller = tabBarController as! MyTabBarController

        addTrade = createButton("Add Trade")
        addTrade.addTarget(self, action: "addTrade:", forControlEvents: .TouchUpInside)

        tradesTable = TradesTable()
        tradesTable.store = controller.store

        view.addSubview(addTrade)
        view.addSubview(tradesTable.view)

        addChildViewController(tradesTable)

        let components:[ComponentWrapper] = [
            ComponentWrapper(view: addTrade, rules: ConstraintRules(parentView: view).centerX().marginTop(150).snapTop()),
            ComponentWrapper(view: tradesTable.view, rules: ConstraintRules(parentView: view).snapBottom().snapTop().marginTop(200).snapLeft().snapRight())
        ]

        SnapKitHelpers.setConstraints(components)
    }

    func addTrade(sender:UIButton){
        controller.store.trades.append(Trade(date: NSDate(),price: 20.0, stock: Stock(ticker: "NAS.OL"), count: 10, action: Action.BUY))
        tradesTable.tableView.reloadData()
    }


}
