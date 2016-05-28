
import Foundation
import UIKit
import SnapKit

class WatchTableViewCell : UITableViewCell {

    var stock:Stock!

    init(stock:Stock){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

        let ticker = createLabel(stock.ticker, font: SUBTITLE_FONT)
        ticker.textColor = SUBTITLE_FONT_COLOR

        let name = createLabel("")
        let value = createLabel("")
        let inc = createLabel("")
        inc.textAlignment = .Center

        if let meta = stock.meta {
            name.text = meta.LONG_NAME!
            value.text = String(format: "%.2f", meta.ASK!)
            inc.text = String(format: "%.2f", meta.CHANGE_PCT_SLACK ?? -1) + "%"
        }

        setIncBackgroundColor(inc, stock: stock)

        addSubview(name)
        addSubview(ticker)
        addSubview(value)
        addSubview(inc)

        SnapKitHelpers.setConstraints([
                ComponentWrapper(view: name, rules: ConstraintRules(parentView: self).snapLeft().marginLeft(8).snapTop().marginTop(5)),
                ComponentWrapper(view: ticker, rules: ConstraintRules(parentView: self).snapLeft().marginLeft(8).snapTop(name.snp_bottom).marginTop(2)),
                ComponentWrapper(view: value, rules: ConstraintRules(parentView: self).snapRight(inc.snp_left).centerY().marginRight(20)),
                ComponentWrapper(view: inc, rules: ConstraintRules(parentView: self).snapRight().marginRight(20).centerY().width(70).height(30))
        ])


    }

    func setIncBackgroundColor(label:UILabel, stock:Stock) {
        if let meta = stock.meta {
            if meta.CHANGE_PCT_SLACK >= 0 {
                label.backgroundColor = UIColor.greenColor()
            } else {
                label.backgroundColor = UIColor.redColor()
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
