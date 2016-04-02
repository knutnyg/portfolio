
import Foundation
import UIKit

class Modal : UIViewController, UIGestureRecognizerDelegate {

    let vc:UIViewController

    init(vc:UIViewController){
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)

        addChildViewController(vc)
        view.addSubview(vc.view)

        let touch = UITapGestureRecognizer(target:self, action:"dismiss:")
        view.addGestureRecognizer(touch)
        touch.delegate = self

        vc.view.backgroundColor = BLUE_GREY

        let comp = [
                ComponentWrapper(view: vc.view, rules: ConstraintRules(parentView: view).centerY(-100).horizontalFullWithMargin(0).height(300))
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(touch.view == view) {
            return true
        } else {
            return false
        }
    }

    func dismiss(sender: UITapGestureRecognizer){
        self.dismissViewControllerAnimated(false, completion: nil)
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
