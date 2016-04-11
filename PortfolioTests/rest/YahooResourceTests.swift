
import Foundation
import XCTest
import BrightFutures

class YahooResourceTests : XCTestCase {

    func testUtbytte() {

        let expectation = expectationWithDescription("promise")

        YahooResource().getDividendsForStock(Stock(ticker: "STL.OSE")).onSuccess{
            (stock:Stock) in
            XCTAssert(stock.dividends != nil)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {
            error in
            XCTAssertNil(error, "Error")
        })
    }
}
