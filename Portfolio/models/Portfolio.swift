import Foundation
import BrightFutures

class Portfolio {

    static func stocksAtDay(store: Store, date: NSDate) throws -> [Stock:Double] {

        var assets: [String:Double] = [:]

        let sortedTrades = store.trades
        .filter({ $0.date.earlierDate(date) == $0.date })
        .sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        for trade in sortedTrades {
            let action: Action = trade.action
            switch action {
            case Action.BUY:
                if let currentAmount = assets[trade.ticker] {
                    assets[trade.ticker] = trade.count + currentAmount
                } else {
                    assets[trade.ticker] = trade.count
                }; break
            case Action.SELL:
                if let currentAmount = assets[trade.ticker] {
                    let newValue = currentAmount - trade.count

                    if newValue >= 0 {
                        assets[trade.ticker] = currentAmount - trade.count
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
        var ret: [Stock:Double] = [:]
        for (k, v) in assets {
            if let stock = store.stocks[k] {
                ret[stock] = v
            }
        }
        return ret
    }

    static func valueAtDay(store: Store, date: NSDate) -> Double? {

        do {

            let now = NSDate()
            let assets: [Stock:Double] = try stocksAtDay(store, date: date)

            var value = 0.0

            for stockWorth in assets {

                if date.isInSameDayAs(date: now) {
                    //Bruk dagens data:
                    if let historyDay = stockWorth.0.intraDayHistory {
                        value += historyDay.currentValue() * stockWorth.1
                    }
                } else {
                    if let stockHistory: StockHistory = stockWorth.0.history {
                        if let v = stockHistory.stockValueAtDay(date) {
                            value += v * stockWorth.1
                        } else {
                            //Find last value
                            return nil
                        }
                    }
                }
            }
            return value
        } catch {
            return nil
        }
    }

    static func stocksFromTrades(trades: [Trade]) -> [Stock] {
        return Array(Set(trades.map {
            Stock(ticker: $0.ticker)
        }))
    }
}
