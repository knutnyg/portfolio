//
// Created by Knut Nygaard on 06/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class StoreTests: XCTestCase {

    class StoreMock: Store {

        override init() {
            super.init()
        }

        required init?(coder decoder: NSCoder) {
            super.init(
                trades: decoder.decodeObjectForKey("trades") as! [Trade],
                allStockInfo: decoder.decodeObjectForKey("allStockInfo") as! AllStockInfo,
                stocks: decoder.decodeObjectForKey("stocks") as! [String:Stock],
                watchedStocks: decoder.decodeObjectForKey("watchedStocks") as! [Stock],
                userPrefs: decoder.decodeObjectForKey("userPrefs") as? UserPreferences
            )

        }


        override func saveStore() {

            if let fileUrl = self.storedFileName {
                synced(self) {
                    if let filePath = getFileURL(fileUrl) {
                        print("Saving store...")
                        NSKeyedArchiver.archiveRootObject(self, toFile: filePath.path!)
                    }
                }
            } else {
                print("Skipping saving store because no url!")
            }
        }
    }

    func testStoreAndLoadCache() {

        let store = StoreMock()
        store.storedFileName = "test-\(NSDate().mediumPrintable()).dat"

        let stock = Stock(ticker: "Test")
        let stockHistory = StockHistory(history:
        [
                StockPriceInstance(date: NSDate(), price: 20.0),
                StockPriceInstance(date: NSDate(timeInterval: 86400, sinceDate: NSDate()), price: 17.0),
                StockPriceInstance(date: NSDate(timeInterval: 2 * 86400, sinceDate: NSDate()), price: 19.0)
        ]
        )
        stock.history = stockHistory
        stock.historyTimestamp = NSDate()

        store.updateStockHistory(stock)
        store.saveStore()

        if let s = store.loadStore() {
            if let maybeStock = s.stocks[stock.ticker] {
                XCTAssert(maybeStock.historyTimestamp != nil)
                XCTAssertEqual(maybeStock.history!.history.count, 3)
            } else {
                print("no stock found")
                XCTAssert(false)
            }
        } else {
            print("no store found")
            XCTAssert(false)
        }
    }
}
