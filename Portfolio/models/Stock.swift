
import Foundation


class Stock : NSObject{

    var ticker:String!
    var currentValue:Double?
    var currentValueTimestamp:NSDate?
    var history:StockHistory?
    var historyTimestamp:NSDate?

    init(ticker:String){
        self.ticker = ticker
    }

    init(ticker:String, history:StockHistory){
        self.ticker = ticker
        self.history = history
    }

    init(ticker:String, currentValue:Double?, currentValueTimestamp: NSDate?, history:StockHistory?, historyTimestamp:NSDate?){
        self.ticker = ticker
        self.currentValue = currentValue
        self.currentValueTimestamp = currentValueTimestamp
        self.history = history
        self.historyTimestamp = historyTimestamp
    }

    func valueAtDay(date: NSDate) -> Double?{
        if let cache = history {
            return cache.stockValueAtDay(date)
        } else {
            return nil
        }
    }

    func withHistory(history:StockHistory) -> Stock {
        self.history = history
        self.historyTimestamp = NSDate()
        return self
    }

    ////     Serialization     ////

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.ticker, forKey: "ticker")
        coder.encodeObject(self.currentValue, forKey: "currentValue")
        coder.encodeObject(self.currentValueTimestamp, forKey: "currentValueTimestamp")
        coder.encodeObject(self.history, forKey: "history")
        coder.encodeObject(self.historyTimestamp, forKey: "historyTimestamp")
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
        ticker: decoder.decodeObjectForKey("ticker") as! String,
                currentValue: decoder.decodeObjectForKey("currentValue") as? Double,
                currentValueTimestamp: decoder.decodeObjectForKey("currentValueTimestamp") as? NSDate,
                history: decoder.decodeObjectForKey("history") as? StockHistory,
                historyTimestamp: decoder.decodeObjectForKey("historyTimestamp") as? NSDate
        )
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


