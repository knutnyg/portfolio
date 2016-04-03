//
// Created by Knut Nygaard on 03/04/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit

class Header: UIViewController {

    var rightButtonCallback: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DARK_GREY
    }

    func withTitle(text:String) -> Header {
        let label = createLabel(text)

        view.addSubview(label)

        SnapKitHelpers.setConstraints(
            [ComponentWrapper(view: label, rules: ConstraintRules(parentView: view).snapBottom().centerX().marginBottom(8))]
        )

        return self
    }

    func withRightButton(text: String, action: (() -> Void)) -> Header {
        let button = UIButton()
        button.setTitle(text, forState: .Normal)
        button.addTarget(self, action: "rightButtonAction:", forControlEvents: .TouchUpInside)
        rightButtonCallback = action

        view.addSubview(button)

        SnapKitHelpers.setConstraints(
            [ComponentWrapper(view: button, rules: ConstraintRules(parentView: view).snapBottom().snapRight().marginBottom(8).marginRight(8))]
        )

        return self
    }

    func rightButtonAction(sender: UIButton) {
        rightButtonCallback()
    }

}
