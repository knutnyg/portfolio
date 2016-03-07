import Foundation
import BrightFutures
import SwiftHTTP
import CSwiftV

class HistoricalDataFetcher {

    static func getHistoricalData(store:Store, stock: Stock) -> Future<StockHistory, NSError> {

        let promise = Promise<StockHistory, NSError>()

        let url = "https://ichart.finance.yahoo.com/table.csv?s=\(stock.ticker)&c=1962&ignore=.csv"

        do {
            if let entry:CacheEntry = store.historicalDataCache.entrys.valueForKey(stock.ticker) as? CacheEntry {
                print("HistoricalDataFetcher: Returning cached datas")
                return Future(value: entry.stockHistory)
            }


            let request = try HTTP.GET(url)

            request.start {
                response in
                if let err = response.error {
                    print("CurrentStockDataFetcher: Response contains error: \(err)")
                    promise.failure(err)
                    return
                }
                print(response.description)
                let resstr: String = NSString(data: response.data, encoding: NSUTF8StringEncoding)! as String
                let csv = CSwiftV(String: resstr)

                let stockHistory = StockHistory(history: self.t(csv.keyedRows!))
                store.updateStore(CacheEntry(stockHistory: stockHistory, date: NSDate()), stock: stock)

                promise.success(stockHistory)
            }
        } catch {
            print("LoginHandler: got error in logInWithDefault")
        }

        return promise.future
    }

    static func t(keyedRows: [[String:String]]) -> [StockPriceInstance] {
        return keyedRows.map({ kr in StockPriceInstance(csvRow: kr) }).reverse()
    }
}
