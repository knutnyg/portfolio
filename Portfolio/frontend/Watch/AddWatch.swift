
import Foundation
import UIKit
import Font_Awesome_Swift

class AddWatch: ModalViewController, AutocompleteViewDelegate {

    var store:Store!

    init(store:Store, callback:(()->Void)?){
        super.init(nibName: nil, bundle: nil)
        self.store = store
        self.callback = callback
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        height = 300

        let header = Header()
        .withTitle("Legg til aksje", color: WHITE, font: nil)
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

    func hideSubComponents() -> Void {
    }

    func showSubComponents() -> Void {
    }

    func userSelectedItem(item:String) {
        store.addWatch(Stock(ticker: item))
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0

        }, completion: dismiss)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
