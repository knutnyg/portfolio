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
    
    static func costAtDay(store: Store, date: NSDate) -> Double? {
        
        var sum = 0.0
        
        
        for (stock, _) in try! Portfolio.stocksAtDay(store, date: date){
            print(stock.ticker)
            sum = sum + Portfolio.averageCostOfStock(store.trades
                .filter{(trade:Trade) in trade.ticker == stock.ticker}
            )!
        }
        
        return sum
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
            return trades
                .map{(trade:Trade) in
                    return ((trade.action==Action.SELL ? -1 : 1) * ((trade.price * trade.count) + ((trade.action==Action.SELL ? -1 : 1) * trade.fee)))}
            .reduce(0,combine: +)
        }
    }
    
    static func rawCostAtDate(trades: [Trade], date:NSDate) -> Double {
        do {
            return trades
                .filter{(trade:Trade) in trade.date.earlierDate(NSDate(timeInterval: 86400, sinceDate: date)) == trade.date}
                .map{(trade:Trade) in
                    return ((trade.action==Action.SELL ? -1 : 1) * ((trade.price * trade.count) + ((trade.action==Action.SELL ? -1 : 1) * trade.fee)))}
                .reduce(0,combine: +)
        }
    }

    static func stocksFromTrades(trades: [Trade]) -> [Stock] {
        return Array(Set(trades.map {
            Stock(ticker: $0.ticker)
        }))
    }

    static func averageCostOfStock(stockTrades:[Trade]) -> Double? {
        do {
            let sumBuy = stockTrades
            .filter{$0.action == Action.BUY}
            .map{($0.price * $0.count) + $0.fee}
            .reduce(0,combine: +)
            
            let numBoughtStocks = Double(stockTrades.filter{$0.action == Action.BUY}.map{$0.count}.reduce(0,combine: +))
            return numBoughtStocks != 0 ? sumBuy/numBoughtStocks : 0
        }
    }
    
    static func averageCostOfStockAtDate(stockTrades:[Trade], date:NSDate) -> Double? {
        do {
            let relevantTrades = stockTrades
                .filter{$0.date.earlierDate(NSDate(timeInterval: 86400, sinceDate: date)) == $0.date}
                .filter{$0.action == Action.BUY}
            let sumBuy = relevantTrades
                .map{($0.price * $0.count) + $0.fee}
                .reduce(0,combine: +)
            
            let numBoughtStocks = Double(relevantTrades.map{$0.count}.reduce(0,combine: +))
            return numBoughtStocks != 0 ? sumBuy/numBoughtStocks : 0
        }
    }

    static func averageSaleOfStock(stockTrades:[Trade]) -> Double? {
        do {
            let sumSell = (stockTrades
            .filter{$0.action == Action.SELL}
            .map{($0.price * $0.count) - $0.fee}
            .reduce(0, combine: +))
            
            let numSoldStocks = Double(stockTrades.filter{$0.action == Action.SELL}.map{$0.count}.reduce(0,combine: +))
            return numSoldStocks != 0 ? sumSell/numSoldStocks : 0
        }
    }

    static func calculateActualSales(trades:[Trade]) -> Double{
        let groupedTrades = trades.categorise{ $0.ticker }

        var actualSales = 0.0

        for (_, trades) in groupedTrades {

            let numSoldStocks = trades
                .filter{$0.action == Action.SELL}
                .map{$0.count}
                .reduce(0, combine: +)

            actualSales += Double(numSoldStocks) * (averageSaleOfStock(trades)! - averageCostOfStock(trades)!)
        }

        return actualSales
    }
}
