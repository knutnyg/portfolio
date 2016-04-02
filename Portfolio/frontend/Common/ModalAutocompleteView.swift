//
// Created by Knut Nygaard on 02/04/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit

class ModalAutocompleteView : UIViewController {

    let titleString:String!
    let store:Store!

    init(title:String, store:Store){
        self.titleString = title
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = createLabel(titleString)
        let autoCompleteView = AutocompleteView(store: store)

        view.backgroundColor = UIColor.greenColor()

        addChildViewController(autoCompleteView)

        view.addSubview(titleLabel)
        view.addSubview(autoCompleteView.view)

        let comp = [
                ComponentWrapper(view: titleLabel, rules: ConstraintRules(parentView: view).centerX().snapTop()),
                ComponentWrapper(view: autoCompleteView.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(8).snapTop(titleLabel.snp_bottom).snapBottom()),
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
