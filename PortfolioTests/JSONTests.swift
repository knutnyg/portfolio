//
// Created by Knut Nygaard on 13/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation
import XCTest

class JSONTests: XCTestCase {

    let jsonStr = "{\"id\": \"8efe36bc981cb7a0a234406ef02fda5e\",\"meta\": {\"sector.timezone.long\": \"Central European Time\",\"request.from\": \"2011-03-12T00:01:00+0100\",\"sector.timezone.short\": \"CET\",\"request.to\": \"2016-03-12T23:59:00+0100\",\"sector.timezone.offset.minutes\": 60},\"rows\": [{\"key\": \"NAS.OSE\",\"values\": {\"series\": {\"c1\": {\"dataSize\": 1254,\"seriesName\": \"c1\",\"data\": [[1300057200000,109],[1300143600000,105.5],[1300230000000,109]],\"columns\": [\"DATE\",\"CLOSE_CA\"]}}},\"meta\": null}]}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!

    func testFindNestedArrayElementInJSON() {
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonStr, options: [])

        if let obj = JSON.findNodeInJSON("data", node: json) as? Array<Array<Double>> {
            XCTAssert(obj[0][0] == 1300057200000.0)
        } else {
            XCTAssert(false)
        }
    }

    func testFindStringElementInJSON(){
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonStr, options: [])

        if let obj = JSON.findNodeInJSON("sector.timezone.long", node: json) as? String {
            XCTAssert(obj == "Central European Time")
        } else {
            XCTAssert(false)
        }
    }

    func testFindColumnsInJSON(){
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonStr, options: [])

        if let obj = JSON.findNodeInJSON("columns", node: json) as? Array<String>{
            XCTAssert(obj.count == 2)
            XCTAssert(obj[0] == "DATE")
            XCTAssert(obj[1] == "CLOSE_CA")
        } else {
            XCTAssert(false)
        }
    }

    func testFindNonExistingInJSON(){
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonStr, options: [])

        if let obj = JSON.findNodeInJSON("GOD", node: json) as? Array<String>{
            XCTAssert(false)
        } else {
            XCTAssert(true)
        }
    }

    func testCastedToWrongObject(){
        let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonStr, options: [])

        if let obj = JSON.findNodeInJSON("data", node: json) as? Array<Double>{
            XCTAssert(false)
        } else {
            XCTAssert(true)
        }
    }




}
