
import Foundation
import XCTest

class PortfolioTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    func testStocksAtDay() {

        let trades = [
                Trade(date: NSDate(dateString: "2015-07-01"),
                        price: 297.00,
                        stock: Stock(ticker: "NAS.OL"),
                        count: 16,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 60,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 40,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 90,
                        action: Action.SELL
                )]

        do {
            var assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-15"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets["NOD.OL"], 60)

            assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-20"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets["NOD.OL"], 100)

            assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-23"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets["NOD.OL"], 10)
        } catch {
            XCTAssert(false)
        }
    }

    func testFailsIfSoldTooMany() {

        let trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 60,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 40,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 110,
                        action: Action.SELL
                )]

        do {
            var assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-22"))
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }

    func testSoldStockNotOwned() {

        let trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        stock: Stock(ticker: "NOD.OL"),
                        count: 60,
                        action: Action.SELL
                )]

        do {
            var assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-22"))
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }
}
