import Foundation
import BrightFutures

class Store: NSObject {
    var stocks: [String:Stock] = [:]
    var trades: [Trade] = []
    var storedFileName: String?
    var allStockInfo: AllStockInfo!

    override init() {
        super.init()
        self.trades = []
        self.stocks = [:]
        self.allStockInfo = AllStockInfo()
    }

    init(dataFile: String) {
        super.init()

        storedFileName = dataFile

        if let store: Store = self.loadStore() {
            self.trades = store.trades
            self.stocks = store.stocks
            self.allStockInfo = store.allStockInfo
        } else {
            print("Failed to load store!")
            self.trades = []
            self.stocks = [:]
            self.allStockInfo = AllStockInfo()
        }
        refreshStoreStockData()
    }

    private func addAllStocks(tickers: [String]) {
        for ticker in tickers {
            stocks[ticker] = Stock(ticker: ticker)
        }
        saveStore()
    }

    func loadStore() -> Store? {
        if let fileURL = storedFileName {
            if let filePath = getFileURL(fileURL) {
                if let path = filePath.path {
                    if let store = NSKeyedUnarchiver.unarchiveObjectWithFile(path) {
                        print("Loading store...")
                        return store as? Store
                    }
                } else {
                    return nil
                }
            }
            return nil
        }
        return nil
    }

    func removeTrade(trade: Trade) {
        if let idx = trades.indexOf(trade) {
            trades.removeAtIndex(idx)
            saveStore()
        } else {
            print("Could not remove trade at index...")
        }
    }

    func addTrade(trade: Trade) {
        self.trades = (self.trades + [trade]).sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
        refreshStoreStockData()
    }

    func updateStockHistory(stock: Stock) {
        if let maybeStock: Stock = stocks[stock.ticker] {
            stocks[maybeStock.ticker] = maybeStock.withHistory(stock.history!)
        } else {
            stocks[stock.ticker] = stock
        }
    }

    func updateStockIntradayHistory(stock: Stock) {
        if let maybeStock:Stock = stocks[stock.ticker] {
            stocks[maybeStock.ticker] = maybeStock.withIntradayHistory(stock)
        } else {
            stocks[stock.ticker] = stock
        }
    }

    func refreshStoreStockData(){
        OsloBorsResource().allStockInformation(self).onSuccess{
            info in
            self.allStockInfo = info
            self.allStockInfo.lastUpdated = NSDate()
            self.saveStore()
        }.onFailure{
            error in
            print("Failure from OsloStockResource")
        }

        OsloBorsResource().updateStockHistories(self, stocks: Portfolio.stocksFromTrades(trades)).onSuccess{
            stocks in
            for stock in stocks {
                self.updateStockHistory(stock)
            }
            self.saveStore()
        }

        OsloBorsResource().updateIntradayHistoryForStocks(Portfolio.stocksFromTrades(trades))
        .onSuccess{
            stocks in
            for stock in stocks {
                self.updateStockIntradayHistory(stock)
            }
            self.saveStore()
        }
    }

    internal func saveStore() {
        if let fileUrl = self.storedFileName {
            synced(self) {
                if let filePath = getFileURL(fileUrl) {
                    print("Saving store...")
                    NSKeyedArchiver.archiveRootObject(self, toFile: filePath.path!)
                }
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name:"StoreChanged", object: self))
            }
        } else {
            print("Skipping saving store because no url!")
        }
    }

    // -----   SERIALIZATION   ----- //

    required convenience init?(coder decoder: NSCoder) {
        print("in real decoder(3)")
        self.init(
        trades: decoder.decodeObjectForKey("trades") as! [Trade],
        allStockInfo: decoder.decodeObjectForKey("allStockInfo") as! AllStockInfo,
        stocks: decoder.decodeObjectForKey("stocks") as! [String:Stock]
        )
    }

    init(trades: [Trade], allStockInfo: AllStockInfo, stocks: [String:Stock]) {
        self.trades = trades
        self.allStockInfo = allStockInfo
        self.stocks = stocks
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.trades, forKey: "trades")
        coder.encodeObject(self.allStockInfo, forKey: "allStockInfo")
        coder.encodeObject(self.stocks, forKey: "stocks")
    }
}
