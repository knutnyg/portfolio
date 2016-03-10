import Foundation
import BrightFutures

class Store: NSObject, NSKeyedUnarchiverDelegate {
    var stocks: [String:Stock] = [:]
    var trades: [Trade] = []
    var historicalDataCache: StockCache!
    var storedFileName: String?

    override init(){
        super.init()
        self.trades = []
        self.stocks = [:]
        self.historicalDataCache = StockCache()
    }

    init(dataFile: String) {
        super.init()

        storedFileName = dataFile

        if let store: Store = self.loadStore() {
            self.trades = store.trades
            self.stocks = store.stocks
            self.historicalDataCache = store.historicalDataCache
        } else {
            print("Failed to load store!")
            self.trades = []
            self.stocks = [:]
            self.historicalDataCache = StockCache()
        }
    }

    private func addAllStocks(tickers:[String]) {
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
        } else {
            print("Not loading store because url not set")
        }
        return nil

    }

    func removeTrade(trade:Trade){
        if let idx = trades.indexOf(trade) {
            trades.removeAtIndex(idx)
            saveStore()
        } else {
            print("Could not remove trade at index...")
        }
    }

    func addTrade(trade: Trade) {
        self.trades = (self.trades + [trade]).sort({$0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
        HistoricalDataFetcher().getHistoricalData(self, ticker: trade.ticker).onSuccess{
            history in
            self.stocks[trade.ticker] = Stock(ticker: trade.ticker, history: history)
            self.saveStore()
        }
    }

    func updateStore(entry: CacheEntry, ticker: String) {
        historicalDataCache.entrys.setObject(entry, forKey: ticker)
        saveStore()
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

    init(trades:[Trade], historicalDataCache: StockCache, stocks:[String:Stock]){
        self.trades = trades
        self.historicalDataCache = historicalDataCache
        self.stocks = stocks
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
            trades: decoder.decodeObjectForKey("trades") as! [Trade],
            historicalDataCache: decoder.decodeObjectForKey("historicalDataCache") as! StockCache,
            stocks: decoder.decodeObjectForKey("stocks") as! [String:Stock]
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.trades, forKey: "trades")
        coder.encodeObject(self.historicalDataCache, forKey: "historicalDataCache")
        coder.encodeObject(self.stocks, forKey: "stocks")
    }
}
