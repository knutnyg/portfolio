import Foundation
import BrightFutures

class Portfolio {

    static func stocksAtDay(trades: [Trade], date: NSDate) throws -> [Stock:Double] {

        var assets: [Stock:Double] = [:]

        let sortedTrades = trades
        .filter({ $0.date.earlierDate(date) == $0.date })
        .sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        for trade in sortedTrades {
            let action: Action = trade.action
            switch action {
            case Action.BUY:
                if let currentAmount = assets[trade.stock] {
                    assets[trade.stock] = trade.count + currentAmount
                } else {
                    assets[trade.stock] = trade.count
                }; break
            case Action.SELL:
                if let currentAmount = assets[trade.stock] {
                    let newValue = currentAmount - trade.count

                    if newValue >= 0 {
                        assets[trade.stock] = currentAmount - trade.count
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

    static func valueAtDay(trades:[Trade], date: NSDate) -> Double?{
        do {
            let assets:[Stock:Double] = try stocksAtDay(trades, date: date)

            var value = 0.0

            for stockDict in assets{

                if let stockHistory = stockDict.0.history {
                    if let stockValue = stockHistory.stockValueAtDay(date) {
                        value += stockValue * stockDict.1
                    } else {
                        return nil
                    }
                }
            }
            return value
        } catch {
            return nil
        }
    }
}
