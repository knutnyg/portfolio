import Foundation

class StockIntradayHistory : NSObject {

    var history: [StockPriceInstance]!
    var timestamp: NSDate!
    var dateValCache: [String:Double] = [:]

    init(history: [StockPriceInstance]) {
        self.history = history
        self.timestamp = NSDate()
        for h in history {
            dateValCache[h.date.timeOfDayPrintable()] = h.price
        }
    }

    func currentValue() -> Double {
        if let last = history.sort({(i:StockPriceInstance, i1:StockPriceInstance) in i.date.compare(i1.date) == NSComparisonResult.OrderedAscending}).last {
            return last.price
        } else {
            return 0.0
        }
    }

    func stockValueAtDay(date: NSDate) -> Double? {
        return dateValCache[date.timeOfDayPrintable()]
    }

    required convenience init?(coder decoder: NSCoder) {
        guard
        let history = decoder.decodeObjectForKey("history") as? [StockPriceInstance]
        else { return nil }

         self.init(
            history: history
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.history, forKey: "history")
    }
}



