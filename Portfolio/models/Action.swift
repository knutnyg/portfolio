
import Foundation

enum Action:Int {
    case BUY
    case SELL

    init?(rawvalue: Int){
        if rawvalue == 0 {
            self = Action.BUY
        } else {
            self = Action.SELL
        }
    }


}
