import Foundation
import UIKit
import SnapKit

class TradesView: UIViewController {

    var addTrade:UIButton!
    var tradesTable:TradesTable!

    override func viewDidLoad() {
        super.viewDidLoad()

        addTrade = createButton("Add Trade")
        tradesTable = TradesTable()

        view.addSubview(addTrade)
        view.addSubview(tradesTable.view)

        addChildViewController(tradesTable)

        let components:[ComponentWrapper] = [
            ComponentWrapper(view: addTrade, rules: ConstraintRules(parentView: view).centerX().marginTop(150).snapTop()),
            ComponentWrapper(view: tradesTable.view, rules: ConstraintRules(parentView: view).snapBottom().snapTop().marginTop(200).snapLeft().snapRight())
        ]

        SnapKitHelpers.setConstraints(components)
    }


}
