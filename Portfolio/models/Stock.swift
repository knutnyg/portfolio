
import Foundation


class Stock : NSObject{

    var ticker:String!
    var intraDayHistory:StockIntradayHistory?
    var history:StockHistory?
    var historyTimestamp:NSDate?
    var meta:StockMeta?
    var dividends:StockDividends?

    init(ticker:String){
        self.ticker = ticker
    }

    init(ticker:String, history:StockHistory){
        self.ticker = ticker
        self.history = history
    }

    init(ticker:String, intraDayHistory:StockIntradayHistory?, history:StockHistory?, historyTimestamp:NSDate?){
        self.ticker = ticker
        self.intraDayHistory = intraDayHistory
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

    func withIntradayHistory(stock:Stock) -> Stock {
        self.intraDayHistory = stock.intraDayHistory
        return self
    }

    func withMeta(meta:StockMeta) -> Stock {
        self.meta = meta
        return self
    }

    func withDividends(dividends:StockDividends) -> Stock {
        self.dividends = dividends
        return self
    }

    ////     Serialization     ////

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.ticker, forKey: "ticker")
        coder.encodeObject(self.intraDayHistory, forKey: "intraDayHistory")
        coder.encodeObject(self.history, forKey: "history")
        coder.encodeObject(self.historyTimestamp, forKey: "historyTimestamp")
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
        ticker: decoder.decodeObjectForKey("ticker") as! String,
                intraDayHistory: decoder.decodeObjectForKey("intraDayHistory") as? StockIntradayHistory,
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


