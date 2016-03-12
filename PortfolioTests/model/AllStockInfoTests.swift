
import Foundation
import XCTest

class AllStockInfoTests : XCTestCase {

    func testGetAllTickers() {

        let allStockinfo = AllStockInfo()
        allStockinfo.rows = [
                Rows(key: "row1", values: createStockInfo("NAS.OSE"), meta: "meta"),
                Rows(key: "row2", values: createStockInfo("NOD.OSE"), meta: "meta"),
                Rows(key: "row3", values: createStockInfo("MHG.OSE"), meta: "meta")
        ]

        try XCTAssertTrue(allStockinfo.getAllTickers().contains("NAS.OSE"))
        try XCTAssertTrue(allStockinfo.getAllTickers().contains("MHG.OSE"))
        try XCTAssertTrue(allStockinfo.getAllTickers().contains("NOD.OSE"))
        try XCTAssertEqual(allStockinfo.getAllTickers().count, 3)
    }


    private func createStockInfo(ticker:String) -> StockInfo{
        return StockInfo(BID: 0, TIME: 0.0, GICS_CODE_LEVEL_1: 0,
                MIC: "", VOLUME_TOTAL: 0.0, ITEM: "", LASTNZ_DIV: 0.0,
                CHANGE_PCT_SLACK: 0.0, HAS_LIQUIDITY_PROVIDER: 0,
                PERIOD: "", TURNOVER_TOTAL: 0.0, ITEM_SECTOR: ticker,
                ASK: 0.0, INSTRUMENT_TYPE: "", TRADE_TIME: 0.0,
                LONG_NAME: "", CLOSE_LAST_TRADED: 0.0, generator: 0.0,
                TRADES_COUNT_TOTAL: 0.0, MARKET_CAP: 0.0)
    }
}
