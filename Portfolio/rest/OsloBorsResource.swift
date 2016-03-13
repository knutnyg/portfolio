import Foundation
import Unbox
import BrightFutures
import SwiftHTTP

class OsloBorsResource {

    func currentValueOfStock() {

    }

    func allStockInformation(store: Store) -> Future<AllStockInfo, NSError> {

        if let info = store.allStockInfo {
            if info.lastUpdated.laterDate(NSDate(timeIntervalSinceNow: -3600 * 24)) == info.lastUpdated {
                print("OsloBorsResource:allStockInformation: Using cached value")
                return Future(value: info)
            }
        }

        let promise = Promise<AllStockInfo, NSError>()

        let URL = "http://www.oslobors.no/ob/servlets/components?" +
                  "type=table&generators%5B0%5D%5Bsource%5D=feed.ob.quotes.EQUITIES%2BPCC&generators%5B1%5D%5Bsource%5D=feed.merk.quotes.EQUITIES%2BPCC&" +
                  "filter=" +
                  "&view=DELAYED" +
                  "&columns=PERIOD" +
                  "%2C+INSTRUMENT_TYPE" +
                  "%2C+TRADE_TIME" +
                  "%2C+ITEM_SECTOR" +
                  "%2C+ITEM" +
                  "%2C+LONG_NAME" +
                  "%2C+BID" +
                  "%2C+ASK" +
                  "%2C+LASTNZ_DIV" +
                  "%2C+CLOSE_LAST_TRADED" +
                  "%2C+CHANGE_PCT_SLACK" +
                  "%2C+TURNOVER_TOTAL" +
                  "%2C+TRADES_COUNT_TOTAL" +
                  "%2C+MARKET_CAP" +
                  "%2C+HAS_LIQUIDITY_PROVIDER" +
                  "%2C+PERIOD%2C+MIC" +
                  "%2C+GICS_CODE_LEVEL_1" +
                  "%2C+TIME" +
                  "%2C+VOLUME_TOTAL" +
                  "&channel=a66b1ba745886f611af56cec74115a51"

        do {
            let request = try HTTP.GET(URL)

            request.start {
                response in
                if let err = response.error {
                    print("OsloBorsResource: Response contains error: \(err)")
                    promise.failure(err)
                    return
                }

                if let obj: AllStockInfo = Unbox(response.data) {
                    promise.success(obj.withLastUpdated(NSDate()))
                } else {
                    promise.failure(NSError(domain: "Parsing", code: 500, userInfo: nil))
                }
            }
        } catch {
            print("Unexpected error in OsloBorsResource")
        }

        return promise.future
    }

    func updateStockHistories(store: Store, stocks: [Stock]) -> Future<[Stock], NSError> {
        let promise = Promise<[Stock], NSError>()

        try! stocks.map({
            (stock: Stock) in getHistoryForStock(store, stock: stock)
        }).sequence().onSuccess {
            updatedStocks in
            promise.success(updatedStocks)
        }

        return promise.future
    }

    private func getHistoryForStock(store: Store, stock: Stock) -> Future<Stock, NSError> {
        let promise = Promise<Stock, NSError>()

        let url = "http://www.oslobors.no/ob/servlets/components/graphdata/(CLOSE_CA)/day/\(stock.ticker)?points=500"

        do {
            if let stock: Stock = store.stocks[stock.ticker] {
                if let timestamp = stock.historyTimestamp {
                    if timestamp.laterDate(NSDate(timeIntervalSinceNow: -3600 * 24)) == timestamp {
                        print("HistoricalDataFetcher: Returning cached datas")
                        return Future(value: stock)
                    }
                }
            }

            let request = try HTTP.GET(url)

            request.start {
                response in
                if let err = response.error {
                    print("OSLOHistory: Response contains error: \(err)")
                    promise.failure(err)
                    return
                }

                var histories: [StockPriceInstance] = []

                let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(response.data, options: [])
                if let data = JSON.findNodeInJSON("data", node: json) as? Array<Array<Double>> {
                    for datePricePair in data {
                        histories.append(StockPriceInstance(date: NSDate(timeIntervalSince1970: (datePricePair[0]/1000)), price: datePricePair[1]))
                    }
                    print("not using cache")
                    stock.history = StockHistory(history: histories)
                    stock.historyTimestamp = NSDate()
                    promise.success(stock)
                } else {
                    promise.failure(NSError(domain: "Parsing", code: 500, userInfo: nil))
                }
            }
        } catch {
            print("LoginHandler: got error in logInWithDefault")
        }
        return promise.future
    }
}
