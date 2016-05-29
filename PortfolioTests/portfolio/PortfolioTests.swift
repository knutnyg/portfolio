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
                        action: Action.BUY,
                        fee: 0

                ),
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.BUY,
                        fee: 0
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY,
                        fee: 0
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        ticker: "NOD.OL",
                        count: 90,
                        action: Action.SELL,
                        fee: 0
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
                        action: Action.BUY,
                        fee: 0
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY,
                        fee: 0
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 37.30,
                        ticker: "NOD.OL",
                        count: 110,
                        action: Action.SELL,
                        fee: 0
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
                        action: Action.SELL,
                        fee: 0
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
        let nodStock = Stock(ticker: "NOD.OL", history: history)
        nodStock.intraDayHistory = StockIntradayHistory(history: [StockPriceInstance(date: NSDate(), price: 60)])

        store.stocks = ["NOD.OL": nodStock]

        store.trades = [
                Trade(date: NSDate(dateString: "2016-02-22"),
                        price: 49.30,
                        ticker: "NOD.OL",
                        count: 60,
                        action: Action.BUY,
                        fee: 0
                ),
                Trade(date: NSDate(dateString: "2016-02-25"),
                        price: 43.30,
                        ticker: "NOD.OL",
                        count: 40,
                        action: Action.BUY,
                        fee: 0
                )]

        var value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-20"))
        XCTAssertEqual(value, 0)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-23"))
        XCTAssertEqual(value, 2622)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-24"))
        XCTAssertEqual(value, 2473.2)

        value = Portfolio.valueAtDay(store, date: NSDate(dateString: "2016-02-26"))
        XCTAssertEqual(value, 4302)

        value = Portfolio.valueAtDay(store, date: NSDate())
        XCTAssertEqual(value, 6000)

    }

    func testCalculateRawCost() {

        let trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 100.0,
                        ticker: "NOD.OL",
                        count: 10,
                        action: Action.BUY,
                        fee: 29
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 200.0,
                        ticker: "NOD.OL",
                        count: 10,
                        action: Action.BUY,
                        fee: 29
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 150.0,
                        ticker: "NOD.OL",
                        count: 10,
                        action: Action.SELL,
                        fee: 29
                )]
        XCTAssertEqual(Portfolio.rawCost(trades), 1587)

    }

    func testActualSales() {
        let trades = [
                Trade(date: NSDate(dateString: "2015-06-13"),
                        price: 10,
                        ticker: "NOD.OL",
                        count: 10,
                        action: Action.BUY,
                        fee: 29
                ),
                Trade(date: NSDate(dateString: "2015-06-19"),
                        price: 20,
                        ticker: "NOD.OL",
                        count: 5,
                        action: Action.BUY,
                        fee: 29
                ),
                Trade(date: NSDate(dateString: "2015-06-21"),
                        price: 22,
                        ticker: "NOD.OL",
                        count: 15,
                        action: Action.SELL,
                        fee: 29
                )]
    XCTAssertEqual(Portfolio.calculateActualSales(trades), 43.000000000000007)
    }
    
    func testAverageCostOfStockAtDate(){
        let trades = [
            Trade(date: NSDate(dateString: "2015-06-13"),
                price: 10,
                ticker: "NOD.OL",
                count: 10,
                action: Action.BUY,
                fee: 29
            ),
            Trade(date: NSDate(dateString: "2015-06-19"),
                price: 20,
                ticker: "NOD.OL",
                count: 5,
                action: Action.BUY,
                fee: 29
            )]
        XCTAssertEqual(Portfolio.averageCostOfStockAtDate(trades, date: NSDate(dateString: "2015-06-13")), 12.9)
        XCTAssertEqual(Portfolio.averageCostOfStockAtDate(trades, date: NSDate(dateString: "2015-06-20")), 17.2)
    }
    
    func testCostAtDay(){
        
        let store = Store()
        store.stocks["NOD.OL"] = Stock(ticker: "NOD.OL")
        store.stocks["NAS.OL"] = Stock(ticker: "NAS.OL")
        
        let trades = [
            Trade(date: NSDate(dateString: "2015-06-13"),
                price: 10,
                ticker: "NOD.OL",
                count: 10,
                action: Action.BUY,
                fee: 29
            ),
            Trade(date: NSDate(dateString: "2015-06-13"),
                price: 30,
                ticker: "NAS.OL",
                count: 10,
                action: Action.BUY,
                fee: 29
            ),
            Trade(date: NSDate(dateString: "2015-06-19"),
                price: 20,
                ticker: "NOD.OL",
                count: 5,
                action: Action.BUY,
                fee: 29
            )]
        
        store.trades = trades
        
        XCTAssertEqual(Portfolio.rawCostAtDate(trades, date: NSDate(dateString: "2015-06-14")), 129.0+329.0)
        XCTAssertEqual(Portfolio.rawCostAtDate(trades, date: NSDate(dateString: "2015-06-20")), 17.2*15 + 329)
    }

}
