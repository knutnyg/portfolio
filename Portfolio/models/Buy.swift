
import Foundation

class Trade {

    var date:NSDate!
    var price:Double!
    var stock:Stock!
    var count:Double!

    init(date: NSDate, price:Double, stock:Stock, count:Double){
        self.date = date
        self.price = price
        self.stock = stock
        self.count = count
    }
}
