
import Foundation


class Stock : NSObject{

    var ticker:String!
    var currentValue:Double?
    var history:StockHistory?

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

    override var hashValue : Int {
        get {
            return self.ticker.hashValue
        }
    }

    override func isEqual(object: AnyObject?) -> Bool {
        guard let object = object as? Stock else { return false }
        return ticker == object.ticker
    }
}


