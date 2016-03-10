import Foundation
import XCTest

class HistoricalDataFetcherTests: XCTestCase {

    func testGetHistoricalDataMock() {

        let expectation = expectationWithDescription("promise")

        let store = Store()
        let ticker = "NAS.OL"

        HistoricalDataFetcherMock().getHistoricalData(store, ticker: ticker).onSuccess {
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

    func testGetCachedValueWhenCacheIsFresh() {
        let expectation = expectationWithDescription("promise")

        var cache = StockCache()
        let stock = Stock(ticker: "notATickerValue")
        let stockHistory = (StockHistory(history:
        [
                StockPriceInstance(date: NSDate(), price: 20.0),
                StockPriceInstance(date: NSDate(timeInterval: 86400, sinceDate: NSDate()), price: 17.0),
                StockPriceInstance(date: NSDate(timeInterval: 2 * 86400, sinceDate: NSDate()), price: 19.0)
        ]
        ))
        stock.history = stockHistory
        cache.entrys.setObject(CacheEntry(stockHistory: stockHistory, date: NSDate()),forKey: stock.ticker)

        let store = Store()
        store.historicalDataCache = cache

        HistoricalDataFetcher().getHistoricalData(store, ticker: stock.ticker).onSuccess {
            history in
            XCTAssertEqual(history.history.count, 3)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetNewValueWhenCacheIsOld() {
        let expectation = expectationWithDescription("promise")

        var cache = StockCache()
        let stock = Stock(ticker: "notATickerValue")
        let stockHistory = (StockHistory(history:
        [
                StockPriceInstance(date: NSDate(), price: 20.0),
                StockPriceInstance(date: NSDate(timeInterval: 86400, sinceDate: NSDate()), price: 17.0),
                StockPriceInstance(date: NSDate(timeInterval: 2 * 86400, sinceDate: NSDate()), price: 19.0)
        ]
        ))
        stock.history = stockHistory
        cache.entrys.setObject(CacheEntry(stockHistory: stockHistory, date: NSDate(timeIntervalSinceNow: -3*3600*24)),forKey: stock.ticker)

        let store = Store()
        store.historicalDataCache = cache

        HistoricalDataFetcher().getHistoricalData(store, ticker: stock.ticker)
        .onSuccess {
            data in
            XCTAssert(false)
            expectation.fulfill()
        }.onFailure {
            error in
            XCTAssert(true)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testUpdateStocks() {

        let expectation = expectationWithDescription("promise")

        var store = Store()
        store.stocks = ["NAS.OL":Stock(ticker: "NAS.OL"),"NOD.OL":Stock(ticker:"NOD.OL")]

        HistoricalDataFetcherMock().updateStockData(store).onSuccess{
            storez in
            XCTAssert(storez.stocks["NAS.OL"]!.history != nil)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })



    }
}
