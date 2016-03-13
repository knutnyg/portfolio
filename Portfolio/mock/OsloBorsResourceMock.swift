
import Foundation
import BrightFutures

class OsloBorsResourceMock : OsloBorsResource {

    override func allStockInformation(store: Store) -> Future<AllStockInfo, NSError> {
        return Future(value: AllStockInfo())
    }

    override func getCurrentValueForStock(store: Store, stock: Stock) -> Future<Stock, NSError> {
        let s:Stock = Stock(ticker: stock.ticker)
        s.currentValueTimestamp = NSDate()
        s.currentValue = Double(arc4random_uniform(300))

        return Future(value: s)
    }

    override func getHistoryForStock(store: Store, stock: Stock) -> Future<Stock, NSError> {

        let instances = [
                StockPriceInstance(date: NSDate(), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 1, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 2, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 3, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 4, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 5, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 6, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 7, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 8, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 9, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1)),
                StockPriceInstance(date: NSDate(timeInterval: -86400 * 10, sinceDate: NSDate()), price: Double(arc4random_uniform(300) + 1))
        ]

        let s:Stock = Stock(ticker: stock.ticker)
        s.history = StockHistory(history: instances)
        s.historyTimestamp = NSDate()

        return Future(value: s)
    }
}
