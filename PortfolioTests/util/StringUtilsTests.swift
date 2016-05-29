//
// Created by Knut Nygaard on 29/05/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class StringUtils : XCTestCase{

    func testNomalization() {
        XCTAssertEqual(normalizeNumberInText("0,001"), "0.001")
        XCTAssertEqual(normalizeNumberInText("0,001.001"), "0.001.001")
        XCTAssertEqual(normalizeNumberInText("0001"), "0001")
        XCTAssertEqual(normalizeNumberInText("0,001,"), "0.001.")
    }

    func testDoubleFromString(){
        XCTAssertEqual(doubleFromString("0.001"), 0.001)
        XCTAssertEqual(doubleFromString("0.001.001"), nil)
        XCTAssertEqual(doubleFromString(".001"), 0.001)
        XCTAssertEqual(doubleFromString("1.001"), 1.001)
        XCTAssertEqual(doubleFromString("0,001"), nil)
        XCTAssertEqual(doubleFromString("0,001,"), nil)
    }

}
