import Foundation

class Store: NSObject {
    var trades: [Trade] = []
    var historicalDataCache: StockCache!
    var storedFileName: String!

    init(dataFile: String) {
        super.init()

        storedFileName = dataFile

        if let store: Store = self.loadStore() {
            self.trades = store.trades
            self.historicalDataCache = store.historicalDataCache
        } else {
            print("Failed to load store!")
            self.trades = []
            self.historicalDataCache = StockCache()
        }
    }

    func loadStore() -> Store? {
        if let filePath = getFileURL(storedFileName) {
            if let store = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath.path!) {
                print("Loading store...")
                return store as? Store
            }
        }
        return nil
    }

    func updateStore(trades: [Trade]) {
        self.trades = trades
        saveStore()
    }

    func updateStore(entry: CacheEntry, stock: Stock) {
        historicalDataCache.entrys.setObject(entry, forKey: stock.ticker)
        saveStore()
    }

    internal func saveStore() {
        synced(self) {
            if let filePath = getFileURL(self.storedFileName) {
                print("Saving store...")
                NSKeyedArchiver.archiveRootObject(self, toFile: filePath.path!)
            }
        }
    }

    // -----   SERIALIZATION   ----- //

    init(trades:[Trade], historicalDataCache: StockCache){
        self.trades = trades
        self.historicalDataCache = historicalDataCache
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
            trades: decoder.decodeObjectForKey("trades") as! [Trade],
            historicalDataCache: decoder.decodeObjectForKey("historicalDataCache") as! StockCache
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.trades, forKey: "trades")
        coder.encodeObject(self.historicalDataCache, forKey: "historicalDataCache")
    }
}
