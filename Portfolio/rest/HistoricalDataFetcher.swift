import Foundation
import BrightFutures
import SwiftHTTP
import CSwiftV

class HistoricalDataFetcher {

    func getHistoricalData(store: Store, ticker: String) -> Future<StockHistory, NSError> {

        let promise = Promise<StockHistory, NSError>()

        let url = "https://ichart.finance.yahoo.com/table.csv?s=\(ticker)&c=1962&ignore=.csv"

        do {
            if let stock:Stock = store.stocks[ticker] {
                if let timestamp = stock.historyTimestamp {
                    if timestamp.laterDate(NSDate(timeIntervalSinceNow: -3600 * 24)) == timestamp {
                        print("HistoricalDataFetcher: Returning cached datas")
                        return Future(value: stock.history!)
                    }
                }
            }

            let request = try HTTP.GET(url)

            request.start {
                response in
                if let err = response.error {
                    print("HistoricalDataFetcher: Response contains error: \(err)")
                    promise.failure(err)
                    return
                }
                print(response.description)
                let resstr: String = NSString(data: response.data, encoding: NSUTF8StringEncoding)! as String
                let csv = CSwiftV(String: resstr)

                let stockHistory = StockHistory(history: self.t(csv.keyedRows!))
                store.updateStockHistory(Stock(ticker: ticker, history: stockHistory))

                promise.success(stockHistory)
            }
        } catch {
            print("LoginHandler: got error in logInWithDefault")
        }

        return promise.future
    }

    func updateStockData(store: Store) -> Future<Store, NSError> {

        let promise = Promise<Store, NSError>()

        let tickers = Array(store.stocks.keys)

        let seq = tickers.map({ getHistoricalData(store, ticker: $0) })

        seq.sequence().onSuccess {
            stockHistories in
            var counter = 0
            for history in stockHistories {
                let ticker = tickers[counter]
                store.stocks[ticker] = Stock(ticker: ticker, history: history)
                counter += 1
            }
            promise.success(store)
        }
        return promise.future
    }

    func t(keyedRows: [[String:String]]) -> [StockPriceInstance] {
        return keyedRows.map({ kr in StockPriceInstance(csvRow: kr) }).reverse()
    }
}
