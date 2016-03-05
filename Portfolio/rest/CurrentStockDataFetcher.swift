
import Foundation
import BrightFutures
import SwiftHTTP

class CurrentStockDataFetcher {

    static func fetchStockData(stock:Stock) -> StockPriceInstance? {
        let url = "http://finance.yahoo.com/webservice/v1/symbols/\(stock.ticker)/quote?format=json"
        return nil
    }

}
