

import Foundation

class CacheEntry : NSObject{

    var stockHistory:StockHistory
    var date:NSDate

    init(stockHistory:StockHistory, date:NSDate){
        self.stockHistory = stockHistory
        self.date = date
    }

    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        guard
        let stockHistory = decoder.decodeObjectForKey("stockHistory") as? StockHistory,
        let date = decoder.decodeObjectForKey("date") as? NSDate
        else { return nil }

        self.init(
        stockHistory: stockHistory,
        date: date
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.stockHistory, forKey: "stockHistory")
        coder.encodeObject(self.date, forKey: "date")

    }
}
