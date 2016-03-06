import Foundation
import BrightFutures

class Portfolio {

    func calculateValueNow() {

    }

    static func stocksAtDay(trades: [Trade], date: NSDate) throws -> [String:Double] {

        var assets: [String:Double] = [:]

        let sortedTrades = trades
        .filter({ $0.date.earlierDate(date) == $0.date })
        .sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        for trade in sortedTrades {
            let action: Action = trade.action
            switch action {
            case Action.BUY:
                if let currentAmount = assets[trade.stock.ticker] {
                    assets[trade.stock.ticker] = trade.count + currentAmount
                } else {
                    assets[trade.stock.ticker] = trade.count
                }; break
            case Action.SELL:
                if let currentAmount = assets[trade.stock.ticker] {
                    let newValue = currentAmount - trade.count

                    if newValue >= 0 {
                        assets[trade.stock.ticker] = currentAmount - trade.count
                    } else {
                        print("Error: Sold more than owned of a stock!")
                        throw Errors.IllegalTrade
                    }
                } else {
                    print("Error: Sold stock not owned!")
                    throw Errors.IllegalTrade
                }; break
            }
        }

        return assets
    }

    static func valueAtDay(stockHistory:[StockHistory], trades:[Trade], date: NSDate) -> Double{
        do {
            let stocks = try stocksAtDay(trades, date: date)

            let value = 0.0

            for (ticker,amount) in stocksAtDay {
                HistoricalDataFetcher().getHistoricalData(Stock(ticker: ticker)).onSuccess{
                    history in
                    let stockValue = history.stockValueAtDay(date)
                    value += stockValue * amount
                }
            }

            return value
        } catch {
        }
    }

    static func caluculatePortfolioValueOverTime() -> Double {


        let valueOverTime: [NSDate:Double]



        return 0
    }

    func stocks(trades: [Trade]) {

    }


}
