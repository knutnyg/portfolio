
import Foundation
import CSwiftV
import BrightFutures
import SwiftHTTP

class YahooResource {

    func getDividendsForStock(stock:Stock) -> Future<Stock, NSError> {

        let promise = Promise<Stock, NSError>()

        let string = stock.ticker
        let index = string.endIndex.advancedBy(-3)
        let sub = string.substringToIndex(index) + "OL"

        let URL = "http://real-chart.finance.yahoo.com/table.csv?s=\(sub)&a=00&b=3&c=2000&d=03&e=10&f=2016&g=v&ignore=.csv"
        
        do {
            let request = try HTTP.GET(URL)

            request.start {
                response in
                if let err = response.error {
                    print("Yahoo: Response contains error: \(err)")
                    promise.failure(err)
                    return
                }

                let csv = CSwiftV(String: String(data:response.data, encoding:NSUTF8StringEncoding)!)

                let dividends = csv.keyedRows!.map{(entry) in Dividends(date: NSDate(dateString: entry["Date"]!), dividends: Double(entry["Dividends"]!)!)}

                promise.success(stock.withDividends(StockDividends(dividends: dividends)))
            }
        } catch {
            print("Unexpected error in OsloBorsResource")
        }

        return promise.future
    }
}
