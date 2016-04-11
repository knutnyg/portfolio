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

    func earliestDate() -> NSDate{
        return history.sort({(i:StockPriceInstance, i1:StockPriceInstance) in i.date.compare(i1.date) == NSComparisonResult.OrderedDescending}).first!.date
    }

    func currentValue() -> Double {
        return history.sort({(i:StockPriceInstance, i1:StockPriceInstance) in i.date.compare(i1.date) == NSComparisonResult.OrderedAscending}).last!.price
    }
}



