
import Foundation
import UIKit
import SnapKit
import Font_Awesome_Swift

class NewTrade: ModalViewController, UITextFieldDelegate, AutocompleteViewDelegate {

    let store:Store!

    var tickerLabel: UILabel!
    var dateLabel: UILabel!
    var priceLabel: UILabel!
    var countLabel: UILabel!

    var autocompleteView: AutocompleteView!
    var dateTextField: UITextField!
    var priceTextField: UITextField!
    var countTextField: UITextField!

    var actionSegmentedControl: UISegmentedControl!
    var saveButton: UIButton!

    var datePicker:UIDatePicker!

    init(store:Store){
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        height = 400

        view.backgroundColor = UIColor.whiteColor()

        let header = Header()
        .withTitle("Add Trade", color: WHITE, font: nil)
        .withRightButtonIcon(FAType.FAClose, action: cancel, color: WHITE)

        tickerLabel = createLabel("Ticker:")
        dateLabel = createLabel("Date:")
        priceLabel = createLabel("Price:")
        countLabel = createLabel("Count:")

        autocompleteView = AutocompleteView(store: store, callback: nil)
        autocompleteView.view.layer.zPosition = 100;
        autocompleteView.delegate = self

        datePicker = UIDatePicker()
        datePicker.date = NSDate()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: "dateSelected:", forControlEvents: .ValueChanged)

        dateTextField = createTextField("")
        dateTextField.text =  NSDate().shortPrintable()
        dateTextField.inputView = datePicker
        dateTextField.delegate = self

        priceTextField = createTextField("")
        priceTextField.keyboardType = .DecimalPad

        countTextField = createTextField("")
        countTextField.keyboardType = .DecimalPad

        actionSegmentedControl = UISegmentedControl(items: ["BUY", "SELL"])
        actionSegmentedControl.selectedSegmentIndex = 0

        saveButton = createButton("Save trade")
        saveButton.addTarget(self, action: "saveTrade:", forControlEvents: .TouchUpInside)

        addChildViewController(header)
        addChildViewController(autocompleteView)

        view.addSubview(header.view)
        view.addSubview(tickerLabel)
        view.addSubview(dateLabel)
        view.addSubview(priceLabel)
        view.addSubview(countLabel)
        view.addSubview(autocompleteView.view)
        view.addSubview(dateTextField)
        view.addSubview(priceTextField)
        view.addSubview(countTextField)
        view.addSubview(actionSegmentedControl)
        view.addSubview(saveButton)

        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().height(40)),
                ComponentWrapper(view: tickerLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(autocompleteView.view.snp_top).marginBottom(3)),
                ComponentWrapper(view: dateLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(dateTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: priceLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(priceTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: countLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(countTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: autocompleteView.view, rules: ConstraintRules(parentView: view).snapTop(header.view.snp_bottom).marginTop(30).horizontalFullWithMargin(8)),
                ComponentWrapper(view: dateTextField, rules: ConstraintRules(parentView: view).snapTop(autocompleteView.view.snp_top).marginTop(60).horizontalFullWithMargin(8)),
                ComponentWrapper(view: priceTextField, rules: ConstraintRules(parentView: view).snapTop(dateTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: countTextField, rules: ConstraintRules(parentView: view).snapTop(priceTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: actionSegmentedControl, rules: ConstraintRules(parentView: view).centerX(-70).snapTop(countTextField.snp_bottom).marginTop(20)),
                ComponentWrapper(view: saveButton, rules: ConstraintRules(parentView: view).snapTop(countTextField.snp_bottom).marginTop(20).centerX(70))
        ]

        SnapKitHelpers.setConstraints(components)
    }

    func userSelectedItem(item:String) {

    }

    func hideSubComponents() -> Void {
        dateLabel.hidden = true
        priceLabel.hidden = true
        countLabel.hidden = true

        dateTextField.hidden = true
        priceTextField.hidden = true
        countTextField.hidden = true
    }

    func showSubComponents() -> Void {
        dateLabel.hidden = false
        priceLabel.hidden = false
        countLabel.hidden = false
        dateTextField.hidden = false
        priceTextField.hidden = false
        countTextField.hidden = false
    }

    func saveTrade(sender:UIButton){
        let action = actionSegmentedControl.selectedSegmentIndex == 0 ? Action.BUY : Action.SELL
        store.addTrade(
            Trade(  date: datePicker.date,
                    price: Double(priceTextField.text!)!,
                    ticker: autocompleteView.searchBar.text!,
                    count: Double(countTextField.text!)!,
                    action: action))
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func dateSelected(sender:UIDatePicker){
        dateTextField.text = sender.date.mediumPrintable()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func moveKeyboardUp() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.frame.origin.y += 150
        })
    }

    func moveKeyboardDown(){
        UIView.animateWithDuration(0.25, animations: {
            self.view.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height + 150)
            self.view.frame.origin.y -= 150
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
