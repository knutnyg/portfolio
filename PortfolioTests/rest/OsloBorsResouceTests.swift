
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
        let expectation = expectationWithDescription("promise")

        let store = Store()
        OsloBorsResource().updateStockHistories(store, stocks: [Stock(ticker: "NAS.OSE")])
        .onSuccess {
            stocks in

            print("testing")
            XCTAssert(stocks[0].ticker == "NAS.OSE")
            print("testing1")
            XCTAssert(stocks[0].history != nil)
            print("testing2")
            XCTAssert(stocks[0].historyTimestamp != nil)
            print("testing3")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }
}
