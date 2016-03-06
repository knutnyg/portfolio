
import Foundation

class Trade : NSObject{

    var date:NSDate!
    var price:Double!
    var stock:Stock!
    var count:Double!
    var action:Action!

    init(date: NSDate, price:Double, stock:Stock, count:Double, action:Action){
        self.date = date
        self.price = price
        self.stock = stock
        self.count = count
        self.action = action
    }

    required convenience init?(coder decoder: NSCoder) {

        self.init(
        date: decoder.decodeObjectForKey("date") as! NSDate,
        price: decoder.decodeObjectForKey("price") as! Double,
        stock: decoder.decodeObjectForKey("stock") as! Stock,
        count: decoder.decodeObjectForKey("count") as! Double,
        action: Action(rawValue: decoder.decodeObjectForKey("action") as! Int)!
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.date, forKey: "date")
        coder.encodeObject(self.price, forKey: "price")
        coder.encodeObject(self.stock, forKey: "stock")
        coder.encodeObject(self.count, forKey: "count")
        coder.encodeObject(self.action.rawValue, forKey: "action")
    }
}
