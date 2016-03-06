import Foundation

class StockPriceInstance: NSObject {

    var date: NSDate!
    var price: Double!

    init(date: NSDate, price: Double) {
        self.date = date
        self.price = price
    }

    init(csvRow: [String:String]) {
        self.date = NSDate(dateString: csvRow["Date"]!)
        self.price = Double(csvRow["Close"]!)
    }

    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        guard
        let date = decoder.decodeObjectForKey("date") as? NSDate,
        let price = decoder.decodeObjectForKey("price") as? Double
        else {
            return nil
        }

        self.init(
            date: date,
            price: price
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.date, forKey: "date")
        coder.encodeObject(self.price, forKey: "price")
    }
}