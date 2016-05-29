
import Foundation
import UIKit
import SnapKit
import Font_Awesome_Swift

class NewTrade: ModalViewController, UITextFieldDelegate, AutocompleteViewDelegate {

    var store:Store!

    var tickerLabel: UILabel!
    var dateLabel: UILabel!
    var priceLabel: UILabel!
    var countLabel: UILabel!
    var feeLabel: UILabel!

    var autocompleteView: AutocompleteView!
    var dateTextField: UITextField!
    var priceTextField: UITextField!
    var countTextField: UITextField!
    var feeTextField: UITextField!

    var actionSegmentedControl: UISegmentedControl!
    var saveButton: UIButton!

    var datePicker:UIDatePicker!

    init(store:Store, callback:(()->Void)?){
        super.init(nibName: nil, bundle: nil)
        self.store = store
        self.callback = callback
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
        feeLabel = createLabel("Fee:")

        autocompleteView = AutocompleteView(store: store, callback: nil)
        autocompleteView.view.layer.zPosition = 100;
        autocompleteView.delegate = self

        datePicker = UIDatePicker()
        datePicker.date = NSDate()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: #selector(dateSelected), forControlEvents: .ValueChanged)

        dateTextField = createTextField("")
        dateTextField.text =  NSDate().mediumPrintable()
        dateTextField.inputView = datePicker
        dateTextField.delegate = self

        priceTextField = createTextField("")
        priceTextField.keyboardType = .DecimalPad

        countTextField = createTextField("")
        countTextField.keyboardType = .DecimalPad
        
        feeTextField = createTextField("")
        feeTextField.text = String(store.userPrefs.lastFeePayed ?? 0)
        feeTextField.keyboardType = .DecimalPad

        actionSegmentedControl = UISegmentedControl(items: ["BUY", "SELL"])
        actionSegmentedControl.selectedSegmentIndex = 0

        saveButton = createButton("Save trade")
        saveButton.addTarget(self, action: #selector(saveTrade), forControlEvents: .TouchUpInside)

        addChildViewController(header)
        addChildViewController(autocompleteView)

        view.addSubview(header.view)
        view.addSubview(tickerLabel)
        view.addSubview(dateLabel)
        view.addSubview(priceLabel)
        view.addSubview(countLabel)
        view.addSubview(feeLabel)
        view.addSubview(autocompleteView.view)
        view.addSubview(dateTextField)
        view.addSubview(priceTextField)
        view.addSubview(countTextField)
        view.addSubview(feeTextField)
        view.addSubview(actionSegmentedControl)
        view.addSubview(saveButton)

        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).horizontalFullWithMargin(0).snapTop().height(40)),
                ComponentWrapper(view: tickerLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(autocompleteView.view.snp_top).marginBottom(3)),
                ComponentWrapper(view: dateLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(dateTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: priceLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(priceTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: feeLabel, rules: ConstraintRules(parentView: view).snapLeft(feeTextField.snp_left).snapCenterY(priceLabel.snp_centerY)),
                ComponentWrapper(view: countLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(countTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: autocompleteView.view, rules: ConstraintRules(parentView: view).snapTop(header.view.snp_bottom).marginTop(30).horizontalFullWithMargin(8)),
                ComponentWrapper(view: dateTextField, rules: ConstraintRules(parentView: view).snapTop(autocompleteView.view.snp_top).marginTop(60).horizontalFullWithMargin(8)),
                ComponentWrapper(view: priceTextField, rules: ConstraintRules(parentView: view).snapTop(dateTextField.snp_bottom).marginTop(40).snapLeft().marginLeft(8).snapRight(feeTextField.snp_left).marginRight(8)),
                ComponentWrapper(view: feeTextField, rules: ConstraintRules(parentView: view).snapCenterY(priceTextField.snp_centerY).snapLeft(priceTextField.snp_right).snapRight().marginRight(8).width(90)),
                ComponentWrapper(view: countTextField, rules: ConstraintRules(parentView: view).snapTop(priceTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: actionSegmentedControl, rules: ConstraintRules(parentView: view).centerX(-70).snapTop(countTextField.snp_bottom).marginTop(20)),
                ComponentWrapper(view: saveButton, rules: ConstraintRules(parentView: view).snapTop(countTextField.snp_bottom).marginTop(20).centerX(70))
        ]

        SnapKitHelpers.setConstraints(components)
    }

    func userSelectedItem(item:String) {
        validateTicker()
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

    func markValidationErrors() {
        validateTicker()
        validatePrice()
        validateFee()
        validateCount()
    }

    func validateTicker() -> String?{
        if let text = autocompleteView.searchBar.text {
            let allTickers = store.allStockInfo.getTickersForAutocomplete()
            if allTickers.map({(item:AutocompleteDataItem) in item.text}).contains(text) {
                autocompleteView.view.layer.borderWidth = 0.0
                return text
            }
        }
        autocompleteView.view.layer.borderWidth = 1.0
        autocompleteView.view.layer.borderColor = UIColor.redColor().CGColor
        return nil
    }

    func validatePrice() {
        if let numberText = priceTextField.text {
            let normalizedNumber = normalizeNumberInText(numberText) as String
            if let _ = doubleFromString(normalizedNumber) {
                priceTextField.layer.borderWidth = 0.0
                return
            }
        }
        priceTextField.layer.borderWidth = 1.0
        priceTextField.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func validateFee() {
        if let numberText = feeTextField.text {
            let normalizedNumber = normalizeNumberInText(numberText) as String
            if let _ = doubleFromString(normalizedNumber) {
                feeTextField.layer.borderWidth = 0.0
                return
            }
        }
        feeTextField.layer.borderWidth = 1.0
        feeTextField.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func validateCount() {
        if let numberText = countTextField.text {
            let normalizedNumber = normalizeNumberInText(numberText) as String
            if let _ = doubleFromString(normalizedNumber) {
                countTextField.layer.borderWidth = 0.0
                return
            }
        }
        countTextField.layer.borderWidth = 1.0
        countTextField.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func validateHasStocksForSale(date:NSDate, count:Double, ticker:String) -> Bool{
        if let held = try! Portfolio.stocksAtDay(store, date: date)[Stock(ticker: ticker)] {
            if held >= count {
                return true
            }
        }
        return false
    }

    func saveTrade(sender:UIButton){
        guard
            let price = doubleFromString(normalizeNumberInText(priceTextField.text!)),
            let ticker = validateTicker(),
            let count = doubleFromString(normalizeNumberInText(countTextField.text!)),
            let fee = doubleFromString(normalizeNumberInText(feeTextField.text!))
        else {
            markValidationErrors()
            return
        }
        
        let action = actionSegmentedControl.selectedSegmentIndex == 0 ? Action.BUY : Action.SELL
        
        if validateHasStocksForSale(datePicker.date, count: count, ticker: ticker) || action==Action.BUY {
            store.userPrefs.lastFeePayed = fee
            store.addTrade(
                Trade(  date: datePicker.date,
                    price: price,
                    ticker: ticker,
                    count: count,
                    action: action,
                    fee: fee))
            self.dismissViewControllerAnimated(false, completion: callback)
        } else {
            let alert = UIAlertController(title: "Kan ikke legge inn salg", message: "Du har ikke aksjene du prøver å selge. Vennligst sjekk at du har valgt riktig aksje.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
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
