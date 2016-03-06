
import Foundation

class StockCache : NSObject, NSCoding{

    var entrys: NSMutableDictionary = NSMutableDictionary()

    // MARK: NSCoding

    override init(){

    }

    init(entrys:NSMutableDictionary){
        self.entrys = entrys
    }

    required init?(coder decoder: NSCoder) {
        self.entrys = decoder.decodeObjectForKey("entrys") as! NSMutableDictionary
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.entrys, forKey: "entrys")
    }
}


