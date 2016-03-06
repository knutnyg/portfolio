//
// Created by Knut Nygaard on 05/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class HistoricalDataFetcherTests : XCTestCase {

    func testGetHistoricalDataIntegration(){

        let expectation = expectationWithDescription("promise")

        let stock = Stock(ticker: "NOD.OL")

        HistoricalDataFetcher().getHistoricalData(stock).onSuccess {
            stockHistory in
            XCTAssertTrue(stockHistory.history.count > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {error in
            XCTAssertNil(error, "Error")
        })
    }

    func testGetHistoricalDataMock(){

        let expectation = expectationWithDescription("promise")

        let stock = Stock(ticker: "NOD.OL")

        HistoricalDataFetcherMock().getHistoricalData(stock).onSuccess {
            stockHistory in
            XCTAssertTrue(stockHistory.history.count > 0)
            XCTAssertTrue(stockHistory.history[5].price > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5, handler: {error in
            XCTAssertNil(error, "Error")
        })
    }


}
