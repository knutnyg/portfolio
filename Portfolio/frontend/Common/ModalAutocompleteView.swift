
import Foundation
import UIKit

class ModalAutocompleteView : UIViewController, AutocompleteViewDelegate {

    let titleString:String!
    let store:Store!
    var callback:(() -> Void)?

    init(title:String, store:Store, callback:(()->Void)?){
        self.titleString = title
        self.store = store
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = createLabel(titleString)
        let autoCompleteView = AutocompleteView(store: store, callback:callback)
        autoCompleteView.delegate = self

        view.backgroundColor = UIColor.greenColor()

        addChildViewController(autoCompleteView)

        view.addSubview(titleLabel)
        view.addSubview(autoCompleteView.view)

        let comp = [
                ComponentWrapper(view: titleLabel, rules: ConstraintRules(parentView: view).centerX().snapTop()),
                ComponentWrapper(view: autoCompleteView.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(8).snapTop(titleLabel.snp_bottom)),
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    func userSelectedItem(item:String) {
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
