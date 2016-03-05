//
// Created by Knut Nygaard on 05/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class HistoricalDataFetcherTests : XCTestCase {

    func testGetHistoricalData(){

        let expectation = expectationWithDescription("promise")

        let stock = Stock(ticker: "NAS.OL")

        HistoricalDataFetcher.getHistoricalData(stock).onSuccess {
            data in
            XCTAssertTrue(data.count > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {error in
            XCTAssertNil(error, "Error")
        })
    }


}
