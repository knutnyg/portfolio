import Foundation

class Store {
    var portfolio: Portfolio!
    var historicalDataCache: StockCache!

    var storedFileName:String!

    init(dataFile:String) {
        storedFileName = dataFile
        if let cache = loadCache() {
            historicalDataCache = cache
        } else {
            historicalDataCache = StockCache()
        }
    }

    func updateCache(entry: CacheEntry, stock: Stock) {
        historicalDataCache.entrys.setObject(entry, forKey: stock.ticker)
        synced(self) {
            self.saveCache(self.historicalDataCache)
        }
    }

    func saveCache(cache: StockCache) {
        if let filePath = getFileURL(storedFileName) {
            NSKeyedArchiver.archiveRootObject(cache, toFile: filePath.path!)
        }
    }

    func loadCache() -> StockCache? {

        if let filePath = getFileURL(storedFileName) {
            if let cache = try NSKeyedUnarchiver.unarchiveObjectWithFile(filePath.path!) {
                return cache as? StockCache
            }

        }
        return nil
    }

    func getFileURL(fileName: String) -> NSURL? {
        do {
            return try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false).URLByAppendingPathComponent(fileName)
        } catch {
            print("Error loading file from device...")
        }
        return nil
    }

}

func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
