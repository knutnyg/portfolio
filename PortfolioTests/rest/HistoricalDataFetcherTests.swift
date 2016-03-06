import Foundation
import XCTest

class HistoricalDataFetcherTests: XCTestCase {

//    func testGetHistoricalDataIntegration() {
//
//        let expectation = expectationWithDescription("promise")
//
//        let stock = Stock(ticker: "NOD.OL")
//
//        HistoricalDataFetcher().getHistoricalData(stock).onSuccess {
//            stockHistory in
//            XCTAssertTrue(stockHistory.history.count > 0)
//            expectation.fulfill()
//        }
//
//        waitForExpectationsWithTimeout(5, handler: {
//            error in
//            XCTAssertNil(error, "Error")
//        })
//    }

    func testGetHistoricalDataMock() {

        let expectation = expectationWithDescription("promise")

        let stock = Stock(ticker: "NOD.OL")

        HistoricalDataFetcherMock.getHistoricalDataMock(stock).onSuccess {
            stockHistory in
            XCTAssertTrue(stockHistory.history.count > 0)
            XCTAssertTrue(stockHistory.history[5].price > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetCachedValue() {
        let expectation = expectationWithDescription("promise")

        var cache = StockCache()
        let stock = Stock(ticker: "Test")
        let stockHistory = (StockHistory(history:
        [
                StockPriceInstance(date: NSDate(), price: 20.0),
                StockPriceInstance(date: NSDate(timeInterval: 86400, sinceDate: NSDate()), price: 17.0),
                StockPriceInstance(date: NSDate(timeInterval: 2 * 86400, sinceDate: NSDate()), price: 19.0)
        ]
        ))
        stock.history = stockHistory
        cache.entrys.setObject(CacheEntry(stockHistory: stockHistory, date: NSDate()),forKey: stock.ticker)

        let store = Store(dataFile: "store_test.dat")
        store.historicalDataCache = cache

        HistoricalDataFetcher.getHistoricalData(store, stock: stock).onSuccess {
            history in
            XCTAssertEqual(history.history.count, 3)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }
}
