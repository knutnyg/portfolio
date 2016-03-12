import Foundation
import Unbox

class Rows: NSObject, Unboxable {
    var key: String!
    var values: StockInfo!
    var meta: String?

    required init(unboxer: Unboxer) {
        self.key = unboxer.unbox("key")
        self.values = unboxer.unbox("values")
        self.meta = unboxer.unbox("meta")
    }

    init(key:String, values: StockInfo, meta:String?){
        self.key = key
        self.values = values
        self.meta = meta
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
        key: decoder.decodeObjectForKey("key") as! String,
                values: decoder.decodeObjectForKey("values") as! StockInfo,
                meta: decoder.decodeObjectForKey("meta") as? String
        )
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.key, forKey: "key")
        coder.encodeObject(self.values, forKey: "values")
        coder.encodeObject(self.meta, forKey: "meta")
    }
}

