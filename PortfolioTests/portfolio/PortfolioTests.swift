
import Foundation
import XCTest

class PortfolioTests: XCTestCase {

    func testStocksAtDay() {

        let nodStock = Stock(ticker: "NOD.OL")

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
            var assets:[Stock:Double] = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-15"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[nodStock], 60)

            assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-20"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[nodStock], 100)

            assets = try Portfolio.stocksAtDay(trades, date: NSDate(dateString: "2015-06-23"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[nodStock], 10)
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

    func testValueAtDay(){
        let expectation = expectationWithDescription("promise")

        HistoricalDataFetcherMock.getHistoricalDataMock(Stock(ticker: "NOD.OL")).onSuccess{
            nodHistory in
            let trades = [
                    Trade(date: NSDate(dateString: "2016-02-22"),
                            price: 49.30,
                            stock: Stock(ticker: "NOD.OL", history: nodHistory),
                            count: 60,
                            action: Action.BUY
                    ),
                    Trade(date: NSDate(dateString: "2016-02-25"),
                            price: 43.30,
                            stock: Stock(ticker: "NOD.OL", history: nodHistory),
                            count: 40,
                            action: Action.BUY
                    )]

            var value = Portfolio.valueAtDay(trades, date: NSDate(dateString: "2016-02-20"))
            XCTAssertEqual(value, 0)

            value = Portfolio.valueAtDay(trades, date: NSDate(dateString: "2016-02-23"))
            XCTAssertEqual(value, 2622)

            value = Portfolio.valueAtDay(trades, date: NSDate(dateString: "2016-02-24"))
            XCTAssertEqual(value, 2473.2)

            value = Portfolio.valueAtDay(trades, date: NSDate(dateString: "2016-02-26"))
            XCTAssertEqual(value, 4302)
            expectation.fulfill()

        }

        waitForExpectationsWithTimeout(5, handler: {error in
            XCTAssertNil(error, "Error")
        })
    }
}
