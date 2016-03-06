import Foundation

class StockHistory {

    var history: [StockPriceInstance]!
    var dateValCache: [NSDate:Double] = [:]

    init(history: [StockPriceInstance]) {
        self.history = history
        for h in history {
            dateValCache[h.date] = h.price
        }
    }

    func stockValueAtDay(date: NSDate) -> Double? {
        return dateValCache[date]
    }
}



