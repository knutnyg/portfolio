//
// Created by Knut Nygaard on 06/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class StoreTests : XCTestCase {

    func testStoreAndLoadCache() {

        var store = Store()
        store.storedFileName = "store_test.dat"

        var cache = StockCache()
        let stock = Stock(ticker: "Test")
        let stockHistory = StockHistory(history:
        [
                StockPriceInstance(date: NSDate(), price: 20.0),
                StockPriceInstance(date: NSDate(timeInterval: 86400, sinceDate: NSDate()), price: 17.0),
                StockPriceInstance(date: NSDate(timeInterval: 2 * 86400, sinceDate: NSDate()), price: 19.0)
        ]
        )

        cache.entrys.setObject(CacheEntry(stockHistory: stockHistory, date: NSDate()),forKey: stock.ticker)

        store.updateCache(CacheEntry(stockHistory: stockHistory, date: NSDate()), stock: stock)
        store.loadCache()

        let entry = store.historicalDataCache.entrys.valueForKey(stock.ticker) as! CacheEntry

        XCTAssertEqual(entry.stockHistory.history.count, 3)
    }
}
