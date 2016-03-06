
import Foundation


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

    func valueAtDay(date: NSDate) -> Double?{
        if let cache = history {
            return cache.stockValueAtDay(date)
        } else {
            return nil
        }

    }

    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        guard let ticker = decoder.decodeObjectForKey("ticker") as? String
        else { return nil }

        self.init(
            ticker: ticker
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.ticker, forKey: "ticker")
    }
}


func ==(lhs: Stock, rhs: Stock) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
