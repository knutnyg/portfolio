//
// Created by Knut Nygaard on 20/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class StockIntraDayHistoryTests : XCTestCase{

    func testCurrentValue(){
        let history:StockIntradayHistory = StockIntradayHistory(history: [
                StockPriceInstance(date: NSDate(timeIntervalSinceNow: -6000), price: 22.0),
                StockPriceInstance(date: NSDate(timeIntervalSinceNow: 0), price: 19.0),
                StockPriceInstance(date: NSDate(timeIntervalSinceNow: -12000), price: 17.0),
                StockPriceInstance(date: NSDate(timeIntervalSinceNow: -18000), price: 25.0),
                StockPriceInstance(date: NSDate(timeIntervalSinceNow: -24000), price: 67.0)
        ])

        XCTAssertEqual(history.currentValue(), 19.0)
    }
}
