
import Foundation

class JSON {

    static func findNodeInJSON(key: String, node: AnyObject) -> AnyObject? {

        if let dictionary = node as? Dictionary<String, AnyObject> {
            if let value = dictionary[key] {
                return value
            } else {
                for obj in dictionary.values {
                    if let res = findNodeInJSON(key, node: obj) {
                        return res
                    }
                }
            }
        } else if let array = node as? Array<AnyObject> {
            for elem in array {
                if let res = findNodeInJSON(key, node: elem) {
                    return res
                }
            }
        }
        return nil

    }
}

