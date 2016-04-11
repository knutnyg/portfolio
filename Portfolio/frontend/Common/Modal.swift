
import Foundation
import UIKit

class Modal : UIViewController, UIGestureRecognizerDelegate {

    let vc:ModalViewController
    var callback:(() -> Void)?

    init(vc:ModalViewController, callback:(() -> Void)?) {
        self.vc = vc
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        view.alpha = 0

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

        vc.view.backgroundColor = WHITE

        let comp = [
                ComponentWrapper(view: vc.view, rules: ConstraintRules(parentView: view).centerY().horizontalFullWithMargin(12).height(vc.height))
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 1.0
        })

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
        }, completion: {bool in self.dismissViewControllerAnimated(false, completion: self.callback)})

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
