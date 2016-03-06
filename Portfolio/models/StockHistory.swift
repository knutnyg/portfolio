
import Foundation

class StockHistory {

    var history: [StockPriceInstance]!

    init(history: [StockPriceInstance]){
        self.history = history
    }

    func stockValueAtDay(date: NSDate) -> Double {
        return history.filter{NSCalendar.currentCalendar().compareDate($0.date, toDate: date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedSame}
        .first!
        .price
    }

}
