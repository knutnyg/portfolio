
import Foundation
import BrightFutures
import SwiftHTTP

class CurrentStockDataFetcher {

    static func fetchStockData(stock:Stock) -> StockPriceInstance? {
        _ = "http://finance.yahoo.com/webservice/v1/symbols/\(stock.ticker)/quote?format=json"
        return nil
    }

}
