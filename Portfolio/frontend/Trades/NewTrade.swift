//
// Created by Knut Nygaard on 07/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class NewTrade: UIViewController, UITextFieldDelegate{

    var store:Store!

    var tickerLabel: UILabel!
    var dateLabel: UILabel!
    var priceLabel: UILabel!
    var countLabel: UILabel!

    var tickerTextField: UITextField!
    var dateTextField: UITextField!
    var priceTextField: UITextField!
    var countTextField: UITextField!

    var actionSegmentedControl: UISegmentedControl!
    var saveButton: UIButton!
    var dismissButton: UIButton!

    var datePicker:UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        tickerLabel = createLabel("Ticker:")
        dateLabel = createLabel("Date:")
        priceLabel = createLabel("Price:")
        countLabel = createLabel("Count:")

        tickerTextField = createTextField("")

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
//        priceTextField.delegate = self

        countTextField = createTextField("")
        countTextField.keyboardType = .DecimalPad

        actionSegmentedControl = UISegmentedControl(items: ["BUY", "SELL"])
        actionSegmentedControl.selectedSegmentIndex = 0

        saveButton = createButton("Save trade")
        saveButton.addTarget(self, action: "saveTrade:", forControlEvents: .TouchUpInside)

        dismissButton = createButton("Dismiss")
        dismissButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)


        view.addSubview(tickerLabel)
        view.addSubview(dateLabel)
        view.addSubview(priceLabel)
        view.addSubview(countLabel)
        view.addSubview(tickerTextField)
        view.addSubview(dateTextField)
        view.addSubview(priceTextField)
        view.addSubview(countTextField)
        view.addSubview(actionSegmentedControl)
        view.addSubview(saveButton)
        view.addSubview(dismissButton)

        let components: [ComponentWrapper] =
        [
                ComponentWrapper(view: tickerLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(tickerTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: dateLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(dateTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: priceLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(priceTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: countLabel, rules: ConstraintRules(parentView: view).snapLeft().marginLeft(8).snapBottom(countTextField.snp_top).marginBottom(3)),
                ComponentWrapper(view: tickerTextField, rules: ConstraintRules(parentView: view).snapTop().marginTop(100).horizontalFullWithMargin(8)),
                ComponentWrapper(view: dateTextField, rules: ConstraintRules(parentView: view).snapTop(tickerTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: priceTextField, rules: ConstraintRules(parentView: view).snapTop(dateTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: countTextField, rules: ConstraintRules(parentView: view).snapTop(priceTextField.snp_bottom).marginTop(40).horizontalFullWithMargin(8)),
                ComponentWrapper(view: actionSegmentedControl, rules: ConstraintRules(parentView: view).centerX().snapTop(countTextField.snp_bottom).marginTop(30)),
                ComponentWrapper(view: saveButton, rules: ConstraintRules(parentView: view).snapTop(actionSegmentedControl.snp_bottom).marginTop(20).centerX()),
                ComponentWrapper(view: dismissButton, rules: ConstraintRules(parentView: view).snapTop(saveButton.snp_bottom).marginTop(20).centerX())
        ]

        SnapKitHelpers.setConstraints(components)
    }

    func saveTrade(sender:UIButton){
        let action = actionSegmentedControl.selectedSegmentIndex == 0 ? Action.BUY : Action.SELL
        store.addTrade(
            Trade(  date: datePicker.date,
                    price: Double(priceTextField.text!)!,
                    stock: Stock(ticker: tickerTextField.text!),
                    count: Double(countTextField.text!)!,
                    action: action))
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func dismiss(sender:UIButton){
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
            //            self.view.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height - 150)
            self.view.frame.origin.y += 150
        })
    }

    func moveKeyboardDown(){
        UIView.animateWithDuration(0.25, animations: {
            self.view.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height + 150)
            self.view.frame.origin.y -= 150
        })
    }

    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField == commentTextField || textField == amountTextField {
//            moveKeyboardDown()
//        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
//        if textField == commentTextField || textField == amountTextField {
//            moveKeyboardUp()
//        }
    }





}
