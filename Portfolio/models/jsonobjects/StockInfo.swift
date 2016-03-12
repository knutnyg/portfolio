import Foundation
import Unbox

class StockInfo: Unboxable {
    var BID: Int!
    var TIME: Double!
    var GICS_CODE_LEVEL_1: Int!
    var MIC: String!
    var VOLUME_TOTAL: Double?
    var ITEM: String!
    var LASTNZ_DIV: Double!
    var CHANGE_PCT_SLACK: Double?
    var HAS_LIQUIDITY_PROVIDER: Int!
    var PERIOD: String!
    var TURNOVER_TOTAL: Double?
    var ITEM_SECTOR: String!
    var ASK: Double!
    var INSTRUMENT_TYPE: String!
    var TRADE_TIME: Double?
    var LONG_NAME: String!
    var CLOSE_LAST_TRADED: Double!
    var generator: Double!
    var TRADES_COUNT_TOTAL: Double?
    var MARKET_CAP: Double!


    init(BID: Int, TIME: Double,
         GICS_CODE_LEVEL_1: Int,
         MIC: String,
         VOLUME_TOTAL: Double?,
         ITEM: String,
         LASTNZ_DIV: Double,
         CHANGE_PCT_SLACK: Double?,
         HAS_LIQUIDITY_PROVIDER: Int,
         PERIOD: String,
         TURNOVER_TOTAL: Double?,
         ITEM_SECTOR: String,
         ASK: Double,
         INSTRUMENT_TYPE: String,
         TRADE_TIME: Double?,
         LONG_NAME: String,
         CLOSE_LAST_TRADED: Double,
         generator: Double,
         TRADES_COUNT_TOTAL: Double?,
         MARKET_CAP: Double) {
        self.BID = BID
        self.TIME = TIME
        self.GICS_CODE_LEVEL_1 = GICS_CODE_LEVEL_1
        self.MIC = MIC
        self.VOLUME_TOTAL = VOLUME_TOTAL
        self.ITEM = ITEM
        self.LASTNZ_DIV = LASTNZ_DIV
        self.CHANGE_PCT_SLACK = CHANGE_PCT_SLACK
        self.HAS_LIQUIDITY_PROVIDER = HAS_LIQUIDITY_PROVIDER
        self.PERIOD = PERIOD
        self.TURNOVER_TOTAL = TURNOVER_TOTAL
        self.ITEM_SECTOR = ITEM_SECTOR
        self.ASK = ASK
        self.INSTRUMENT_TYPE = INSTRUMENT_TYPE
        self.TRADE_TIME = TRADE_TIME
        self.LONG_NAME = LONG_NAME
        self.CLOSE_LAST_TRADED = CLOSE_LAST_TRADED
        self.generator = generator
        self.TRADES_COUNT_TOTAL = TRADES_COUNT_TOTAL
        self.MARKET_CAP = MARKET_CAP
    }


    required init(unboxer: Unboxer) {
        self.BID = unboxer.unbox("BID")
        self.TIME = unboxer.unbox("TIME")
        self.GICS_CODE_LEVEL_1 = unboxer.unbox("GICS_CODE_LEVEL_1")
        self.MIC = unboxer.unbox("MIC")
        self.VOLUME_TOTAL = unboxer.unbox("VOLUME_TOTAL")
        self.ITEM = unboxer.unbox("ITEM")
        self.LASTNZ_DIV = unboxer.unbox("LASTNZ_DIV")
        self.CHANGE_PCT_SLACK = unboxer.unbox("CHANGE_PCT_SLACK")
        self.HAS_LIQUIDITY_PROVIDER = unboxer.unbox("HAS_LIQUIDITY_PROVIDER")
        self.PERIOD = unboxer.unbox("PERIOD")
        self.TURNOVER_TOTAL = unboxer.unbox("TURNOVER_TOTAL")
        self.ITEM_SECTOR = unboxer.unbox("ITEM_SECTOR")
        self.ASK = unboxer.unbox("ASK")
        self.INSTRUMENT_TYPE = unboxer.unbox("INSTRUMENT_TYPE")
        self.TRADE_TIME = unboxer.unbox("TRADE_TIME")
        self.LONG_NAME = unboxer.unbox("LONG_NAME")
        self.CLOSE_LAST_TRADED = unboxer.unbox("CLOSE_LAST_TRADED")
        self.generator = unboxer.unbox("generator")
        self.TRADES_COUNT_TOTAL = unboxer.unbox("TRADES_COUNT_TOTAL")
        self.MARKET_CAP = unboxer.unbox("MARKET_CAP")
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
        BID: decoder.decodeObjectForKey("BID") as! Int,
                TIME: decoder.decodeObjectForKey("TIME") as! Double,
                GICS_CODE_LEVEL_1: decoder.decodeObjectForKey("GICS_CODE_LEVEL_1") as! Int,
                MIC: decoder.decodeObjectForKey("MIC") as! String,
                VOLUME_TOTAL: decoder.decodeObjectForKey("VOLUME_TOTAL") as? Double,
                ITEM: decoder.decodeObjectForKey("ITEM") as! String,
                LASTNZ_DIV: decoder.decodeObjectForKey("LASTNZ_DIV") as! Double,
                CHANGE_PCT_SLACK: decoder.decodeObjectForKey("CHANGE_PCT_SLACK") as? Double,
                HAS_LIQUIDITY_PROVIDER: decoder.decodeObjectForKey("HAS_LIQUIDITY_PROVIDER") as! Int,
                PERIOD: decoder.decodeObjectForKey("PERIOD") as! String,
                TURNOVER_TOTAL: decoder.decodeObjectForKey("TURNOVER_TOTAL") as? Double,
                ITEM_SECTOR: decoder.decodeObjectForKey("ITEM_SECTOR") as! String,
                ASK: decoder.decodeObjectForKey("ASK") as! Double,
                INSTRUMENT_TYPE: decoder.decodeObjectForKey("INSTRUMENT_TYPE") as! String,
                TRADE_TIME: decoder.decodeObjectForKey("TRADE_TIME") as? Double,
                LONG_NAME: decoder.decodeObjectForKey("LONG_NAME") as! String,
                CLOSE_LAST_TRADED: decoder.decodeObjectForKey("CLOSE_LAST_TRADED") as! Double,
                generator: decoder.decodeObjectForKey("generator") as! Double,
                TRADES_COUNT_TOTAL: decoder.decodeObjectForKey("TRADES_COUNT_TOTAL") as? Double,
                MARKET_CAP: decoder.decodeObjectForKey("MARKET_CAP") as! Double
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.BID, forKey: "BID")
        coder.encodeObject(self.TIME, forKey: "TIME")
        coder.encodeObject(self.GICS_CODE_LEVEL_1, forKey: "GICS_CODE_LEVEL_1")
        coder.encodeObject(self.MIC, forKey: "MIC")
        coder.encodeObject(self.VOLUME_TOTAL, forKey: "VOLUME_TOTAL")
        coder.encodeObject(self.ITEM, forKey: "ITEM")
        coder.encodeObject(self.LASTNZ_DIV, forKey: "LASTNZ_DIV")
        coder.encodeObject(self.CHANGE_PCT_SLACK, forKey: "CHANGE_PCT_SLACK")
        coder.encodeObject(self.HAS_LIQUIDITY_PROVIDER, forKey: "HAS_LIQUIDITY_PROVIDER")
        coder.encodeObject(self.PERIOD, forKey: "PERIOD")
        coder.encodeObject(self.TURNOVER_TOTAL, forKey: "TURNOVER_TOTAL")
        coder.encodeObject(self.ITEM_SECTOR, forKey: "ITEM_SECTOR")
        coder.encodeObject(self.ASK, forKey: "ASK")
        coder.encodeObject(self.INSTRUMENT_TYPE, forKey: "INSTRUMENT_TYPE")
        coder.encodeObject(self.TRADE_TIME, forKey: "TRADE_TIME")
        coder.encodeObject(self.LONG_NAME, forKey: "LONG_NAME")
        coder.encodeObject(self.CLOSE_LAST_TRADED, forKey: "CLOSE_LAST_TRADED")
        coder.encodeObject(self.generator, forKey: "generator")
        coder.encodeObject(self.TRADES_COUNT_TOTAL, forKey: "TRADES_COUNT_TOTAL")
        coder.encodeObject(self.MARKET_CAP, forKey: "MARKET_CAP")
    }
}
