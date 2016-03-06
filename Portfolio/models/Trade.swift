
import Foundation

class Trade {

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
}
