
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

    func testReturnsCachedValue(){

    }
}
