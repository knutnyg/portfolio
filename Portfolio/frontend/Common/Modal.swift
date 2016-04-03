
import Foundation
import UIKit

class Modal : UIViewController, UIGestureRecognizerDelegate {

    let vc:UIViewController
    var callback:(() -> Void)?

    init(vc:UIViewController, callback:(() -> Void)?) {
        self.vc = vc
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)

        addChildViewController(vc)
        view.addSubview(vc.view)

        vc.view.layer.cornerRadius = 10.0
        vc.view.layer.shadowColor = UIColor.blackColor().CGColor
        vc.view.layer.shadowOffset = CGSizeZero
        vc.view.layer.shadowOpacity = 0.5
        vc.view.layer.shadowRadius = 5

        let touch = UITapGestureRecognizer(target:self, action:"dismiss:")
        view.addGestureRecognizer(touch)
        touch.delegate = self

        vc.view.backgroundColor = BLUE_GREY

        let comp = [
                ComponentWrapper(view: vc.view, rules: ConstraintRules(parentView: view).snapBottom().marginBottom(-150).horizontalFullWithMargin(0).height(300))
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        SnapKitHelpers.updateConstraints([ComponentWrapper(view: vc.view, rules: ConstraintRules(parentView: view).snapBottom().marginBottom(190).horizontalFullWithMargin(12).height(300))])
        UIView.animateWithDuration(0.30, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: view.layoutIfNeeded, completion: nil)

    }


    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if(touch.view == view) {
            return true
        } else {
            return false
        }
    }

    func dismiss(sender: UITapGestureRecognizer){
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0

        }, completion: d)

    }

    func d(bool:Bool) {
        self.dismissViewControllerAnimated(false, completion: callback)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
