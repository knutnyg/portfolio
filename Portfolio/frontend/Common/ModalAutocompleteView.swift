
import Foundation
import UIKit
import Font_Awesome_Swift

class ModalAutocompleteView : UIViewController, AutocompleteViewDelegate {

    var titleText:String!

    let store:Store!
    var callback:(() -> Void)?

    init(title: String, store:Store, callback:(()->Void)?){
        self.titleText = title
        self.store = store
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let header = Header()
        .withTitle(titleText, color: WHITE, font: nil)
        .withRightButtonIcon(FAType.FAClose, action: cancel, color: WHITE)

        let autoCompleteView = AutocompleteView(store: store, callback:callback)
        autoCompleteView.delegate = self

        view.backgroundColor = WHITE

        addChildViewController(autoCompleteView)
        addChildViewController(header)

        view.addSubview(header.view)
        view.addSubview(autoCompleteView.view)

        let comp = [
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).height(40).snapTop()),
                ComponentWrapper(view: autoCompleteView.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(8).snapTop(header.view.snp_bottom).marginTop(8)),
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    func cancel(){
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0

        }, completion: d)
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
