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

    // MARK: NSCoding

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



