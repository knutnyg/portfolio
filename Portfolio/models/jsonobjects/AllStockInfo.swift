import Foundation
import Unbox

class AllStockInfo: NSObject, Unboxable {
    var id: String!
    var rows: [Rows]!
    var lastUpdated: NSDate!

    override init(){
        super.init()
    }

    required init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.rows = unboxer.unbox("rows")
        self.lastUpdated = NSDate()
    }

    func withLastUpdated(date: NSDate) -> AllStockInfo {
        self.lastUpdated = date
        return self
    }

    init(id:String, rows:[Rows], lastUpdated:NSDate){
        self.id = id
        self.rows = rows
        self.lastUpdated = lastUpdated
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init(
        id: decoder.decodeObjectForKey("id") as? String ?? "",
        rows: decoder.decodeObjectForKey("rows") as? [Rows] ?? [],
        lastUpdated: decoder.decodeObjectForKey("lastUpdated") as? NSDate ?? NSDate(timeIntervalSince1970: 0))
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.id, forKey: "id")
        coder.encodeObject(self.rows, forKey: "rows")
        coder.encodeObject(self.lastUpdated, forKey: "lastUpdated")
    }
}