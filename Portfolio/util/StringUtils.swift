

import Foundation

func normalizeNumberInText(input:String) -> String{
    return input.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
}

func doubleFromString(input:String) -> Double? {
    return Double(input)
}