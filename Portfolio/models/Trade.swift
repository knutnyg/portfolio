
import Foundation

class Trade : NSObject{

    var date:NSDate!
    var price:Double!
    var ticker:String!
    var count:Double!
    var action:Action!
    var fee:Double!

    init(date: NSDate, price:Double, ticker:String, count:Double, action:Action, fee:Double){
        self.date = date
        self.price = price
        self.ticker = ticker
        self.count = count
        self.action = action
        self.fee = fee
    }

    required convenience init?(coder decoder: NSCoder) {

        self.init(
        date: decoder.decodeObjectForKey("date") as! NSDate,
        price: decoder.decodeObjectForKey("price") as! Double,
        ticker: decoder.decodeObjectForKey("ticker") as! String,
        count: decoder.decodeObjectForKey("count") as! Double,
        action: Action(rawValue: decoder.decodeObjectForKey("action") as! Int)!,
        fee: decoder.decodeDoubleForKey("fee") ?? 0
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.date, forKey: "date")
        coder.encodeObject(self.price, forKey: "price")
        coder.encodeObject(self.ticker, forKey: "ticker")
        coder.encodeObject(self.count, forKey: "count")
        coder.encodeObject(self.action.rawValue, forKey: "action")
        coder.encodeDouble(fee, forKey: "fee")
    }
}
