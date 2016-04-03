//
// Created by Knut Nygaard on 03/04/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit

class CellViewController : UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = createLabel("Test")
        let chart = LineChartKomponent(data: [StockPriceInstance(date: NSDate(), price: 22.2)])
        chart.visibleXRange = 10

        addChildViewController(chart)

        view.addSubview(label)
        view.addSubview(chart.view)

        let comp = [
                ComponentWrapper(view: label, rules: ConstraintRules(parentView: view).centerX().centerY()),
                ComponentWrapper(view: chart.view, rules: ConstraintRules(parentView: view).snapRight().width(100).height(50))
        ]

        SnapKitHelpers.setConstraints(comp)

    }


}
