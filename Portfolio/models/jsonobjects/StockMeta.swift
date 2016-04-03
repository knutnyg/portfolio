import Foundation

class StockMeta {

    var ASK: Double?
    var BID: Double?
    var CHANGE_PCT_SLACK: Double?
    var CLOSE_LAST_TRADED: Double?
    var HIGH: Double?
    var ITEM: String?
    var ITEM_SECTOR: String?
    var LASTNZ_DIV: Double?
    var LOW: Double?
    var MARKET_CAP: Double?
    var PERIOD: Double?
    var SECTOR: String?
    var TIME: Double?
    var TRADE_TIME: Double?
    var TURNOVER_TOTAL: Double?
    var LONG_NAME: String?
    var timestamp:NSDate!

    init(data: [String:AnyObject]) {
        ASK = data["ASK"] as? Double
        BID = data["BID"] as? Double
        CHANGE_PCT_SLACK = data["CHANGE_PCT_SLACK"] as? Double
        CLOSE_LAST_TRADED = data["CLOSE_LAST_TRADED"] as? Double
        HIGH = data["HIGH"] as? Double
        ITEM = data["ITEM"] as? String
        ITEM_SECTOR = data["ITEM_SECTOR"] as? String
        LASTNZ_DIV = data["LASTNZ_DIV"] as? Double
        LOW = data["LOW"] as? Double
        MARKET_CAP = data["MARKET_CAP"] as? Double
        PERIOD = data["PERIOD"] as? Double
        SECTOR = data["SECTOR"] as? String
        TIME = data["TIME"] as? Double
        TRADE_TIME = data["TRADE_TIME"] as? Double
        TURNOVER_TOTAL = data["TURNOVER_TOTAL"] as? Double
        LONG_NAME = data["LONG_NAME"] as? String
        timestamp = NSDate()
    }

}
