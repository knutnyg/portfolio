
import Foundation
import BrightFutures
import XCTest

class OsloBorsResouceTests : XCTestCase {

    var skipIntegration:Bool = true

    func testGetHistoricalDataMock() {

        if skipIntegration {
            return
        }

        let expectation = expectationWithDescription("promise")

        let store = Store()

        OsloBorsResource().allStockInformation(store).onSuccess{
            response in
            XCTAssert(response.rows.count > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetHistories(){

        if skipIntegration {
            return
        }

        let expectation = expectationWithDescription("promise")

        let store = Store()
        OsloBorsResource().updateStockHistories(store, stocks: [Stock(ticker: "NAS.OSE")])
        .onSuccess {
            stocks in
            XCTAssert(stocks[0].ticker == "NAS.OSE")
            XCTAssert(stocks[0].history != nil)
            XCTAssert(stocks[0].historyTimestamp != nil)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetHistoriesMock(){

        let expectation = expectationWithDescription("promise")

        let store = Store()
        OsloBorsResourceMock().updateStockHistories(store, stocks: [Stock(ticker: "NAS.OSE")])
        .onSuccess {
            stocks in
            XCTAssert(stocks[0].ticker == "NAS.OSE")
            XCTAssert(stocks[0].history != nil)
            XCTAssert(stocks[0].historyTimestamp != nil)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetCurrentValuesMock(){

        let expectation = expectationWithDescription("promise")

        let store = Store()
        OsloBorsResourceMock().updateStocksCurrentValue(store, stocks: [Stock(ticker: "NAS.OSE"), Stock(ticker: "NOD.OSE")])
        .onSuccess {
            (stocks:[Stock]) in
            XCTAssert(stocks[0].ticker == "NAS.OSE")
            XCTAssert(stocks[0].currentValue > 0 && stocks[0].currentValue < 301)
            XCTAssert(stocks[0].currentValueTimestamp!.isInSameDayAs(date: NSDate()))

            XCTAssert(stocks[1].ticker == "NOD.OSE")
            XCTAssert(stocks[1].currentValue > 0 && stocks[0].currentValue < 301)
            XCTAssert(stocks[1].currentValueTimestamp!.isInSameDayAs(date: NSDate()))
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }
}
