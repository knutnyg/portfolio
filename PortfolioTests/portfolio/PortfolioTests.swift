import Foundation
import XCTest

class PortfolioTests: XCTestCase {

    func testStocksAtDay() {

        let store = Store()
        store.trades = [
                Trade(date: NSDate(dateString: "2015-07-01"),
                        price: 297.00,
                        ticker: "NAS.OL",
                        count: 16,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        ticker: "NOD.OL",
                        count: 90,
                        action: Action.SELL
                )]

        store.stocks["NOD.OL"] = Stock(ticker: "NOD.OL")
        store.stocks["NAS.OL"] = Stock(ticker: "NAS.OL")

        let stock = Stock(ticker: "NOD.OL")

        do {
            var assets: [Stock:Double] = try Portfolio.stocksAtDay(store, date: NSDate(dateString: "2015-06-15"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[stock], 60)

            assets = try Portfolio.stocksAtDay(store, date: NSDate(dateString: "2015-06-20"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[stock], 100)

            assets = try Portfolio.stocksAtDay(store, date: NSDate(dateString: "2015-06-23"))
            XCTAssertEqual(assets.count, 1)
            XCTAssertEqual(assets[stock], 10)
        } catch {
            XCTAssert(false)
        }
    }

    func testFailsIfSoldTooMany() {

        let store = Store()
        store.trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        ticker: "NOD.OL",
                        count: 110,
                        action: Action.SELL
                )]

        do {
            var assets = try Portfolio.stocksAtDay(store, date: NSDate(dateString: "2015-06-22"))
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }

    func testSoldStockNotOwned() {

        let store = Store()
        store.trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.SELL
                )]

        do {
            var assets = try Portfolio.stocksAtDay(store, date: NSDate(dateString: "2015-06-22"))
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }

    func testValueAtDay() {

        let store: Store = Store()
        let history = StockHistory(history: [
                StockPriceInstance(date: NSDate(dateString: "2016-02-23"), price: 43.70),
                StockPriceInstance(date: NSDate(dateString: "2016-02-24"), price: 41.22),
                StockPriceInstance(date: NSDate(dateString: "2016-02-26"), price: 43.02),
        ])

        store.stocks = ["NOD.OL": Stock(ticker: "NOD.OL", history: history)]
        store.trades = [
                Trade(date: NSDate(dateString: "2016-02-22"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.BUY
                ),
                Trade(date: NSDate(dateString: "2016-02-25"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY
                )]

        var value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-20"))
        XCTAssertEqual(value, 0)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-23"))
        XCTAssertEqual(value, 2622)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-24"))
        XCTAssertEqual(value, 2473.2)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-26"))
        XCTAssertEqual(value, 4302)

    }

}
