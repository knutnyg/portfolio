import Foundation

class StockHistory : NSObject {

    var history: [StockPriceInstance]!
    var dateValCache: [String:Double] = [:]

    init(history: [StockPriceInstance]) {
        self.history = history
        for h in history {
            dateValCache[h.date.mediumPrintable()] = h.price
        }
    }

    func stockValueAtDay(date: NSDate) -> Double? {
        return dateValCache[date.mediumPrintable()]
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
}



