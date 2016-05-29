
import Foundation

class UserPreferences : NSObject {
    var lastFeePayed:Double?
    
    override init(){
        super.init()
    }
    
    init(lastFeePayed:Double?){
        self.lastFeePayed = lastFeePayed
    }
    
    ////     Serialization     ////
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.lastFeePayed, forKey: "lastFeePayed")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init(
            lastFeePayed: (decoder.decodeObjectForKey("lastFeePayed") as? Double)
        )
    }
}


