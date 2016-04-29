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

    static func lastClosingValue(store:Store) -> Double?{
        let counter = 1.0

        var date = NSDate(timeInterval: -86400, sinceDate: NSDate())
        var val:Double?

        while counter < 30 {
            val = valueAtDay(store, date: date)
            if let v = val {
                return v
            } else {
                date = NSDate(timeInterval: -86400 * counter, sinceDate: date)
            }
        }
        return nil
    }

    static func valueNow(store: Store) -> Double? {
        return valueAtDay(store, date: NSDate())
    }

    static func rawCost(trades: [Trade]) -> Double {
        do {
            return try trades
            .filter{(trade:Trade) in trade.action == Action.BUY}
            .map{(trade:Trade) in (trade.price * trade.count) + trade.fee}
            .reduce(0,combine: +)
        } catch {
            return 0.0
        }
    }

    static func stocksFromTrades(trades: [Trade]) -> [Stock] {
        return Array(Set(trades.map {
            Stock(ticker: $0.ticker)
        }))
    }

    static func averageCostOfStock(stockTrades:[Trade]) -> Double? {
        do {
            let sumBuy = try! stockTrades
            .filter{$0.action == Action.BUY}
            .map{($0.price * $0.count) + $0.fee}
            .reduce(0,combine: +)

            return try! sumBuy / Double(stockTrades.filter{$0.action == Action.BUY}.map{$0.count}.reduce(0,combine: +))
        } catch {
        }
    }

    static func averageSaleOfStock(stockTrades:[Trade]) -> Double? {
        do {
            let sumSell = try (stockTrades
            .filter{$0.action == Action.SELL}
            .map{($0.price * $0.count) - $0.fee}
            .reduce(0, combine: +))

            return try! sumSell / Double(stockTrades.filter{$0.action == Action.BUY}.map{$0.count}.reduce(0,combine: +))
        } catch {
        }
    }

    static func calculateActualSales(trades:[Trade]) -> Double{
        let groupedTrades = trades.categorise{ $0.ticker }

        var actualSales = 0.0

        for (ticker, trades) in groupedTrades {

            let numSoldStocks = trades
                .filter{$0.action == Action.SELL}
                .map{$0.count}
                .reduce(0, combine: +)

            actualSales += Double(numSoldStocks) * (averageSaleOfStock(trades)! - averageCostOfStock(trades)!)
        }

        return actualSales
    }
}
