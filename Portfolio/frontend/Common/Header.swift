
import Foundation
import UIKit
import Font_Awesome_Swift

class Header: UIViewController {

    var rightButtonCallback: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DARK_GREY
    }

    func withTitle(text:String, color:UIColor?, font:UIFont?) -> Header {
        let label = createLabel(text)

        if let col = color {
            label.textColor = color
        }

        if let f = font {
            label.font = font
        }

        view.addSubview(label)

        SnapKitHelpers.setConstraints(
            [ComponentWrapper(view: label, rules: ConstraintRules(parentView: view).snapBottom().centerX().marginBottom(8))]
        )

        return self
    }

    func withRightButtonText(text: String, action: (() -> Void)) -> Header {
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

    func withRightButtonIcon(icon: FAType, action: (() -> Void), color:UIColor) -> Header {
        let button = UIButton()
        button.setFAIcon(icon, iconSize: 20, forState: .Normal)
        button.setTitleColor(color, forState: .Normal)
        button.addTarget(self, action: "rightButtonAction:", forControlEvents: .TouchUpInside)
        rightButtonCallback = action

        view.addSubview(button)

        SnapKitHelpers.setConstraints(
        [ComponentWrapper(view: button, rules: ConstraintRules(parentView: view).snapBottom().snapRight().marginBottom(0).marginRight(4))]
        )

        return self
    }

    func rightButtonAction(sender: UIButton) {
        rightButtonCallback()
    }

}
