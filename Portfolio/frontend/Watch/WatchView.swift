//
// Created by Knut Nygaard on 13/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit

class WatchView : UIKit.UIViewController {

    var button:UIButton!
    var controller:MyTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()

        controller = tabBarController as! MyTabBarController

        button = createButton("To stock")
        button.addTarget(self, action: "toStock:", forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(button)

        let comp = [
            ComponentWrapper(view: button, rules: ConstraintRules(parentView: view).centerX().centerY())
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    func toStock(sender:UIButton){
        let vc = StockView(store: controller.store, stock: Stock(ticker: "NAS.OSE"))
        presentViewController(vc, animated: false, completion: nil)
    }
}
