
import Foundation

func ==(lhs: Stock, rhs: Stock) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class Stock : Hashable {

    var ticker:String!
    var history:StockHistory?

    var hashValue : Int {
        get {
            return self.ticker.hashValue
        }
    }

    init(ticker:String){
        self.ticker = ticker
    }

    init(ticker:String, history:StockHistory){
        self.ticker = ticker
        self.history = history
    }
}
