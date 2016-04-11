import Foundation

class StockDividends {
    var dividends:[Dividends]!
    var timestamp:NSDate!

    init(dividends:[Dividends]){
        self.dividends = dividends
        self.timestamp = NSDate()
    }
}
