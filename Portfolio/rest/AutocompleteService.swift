//
// Created by Knut Nygaard on 12/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation

class AutocompleteService {

    static func autoCompleteForInput(tickers: [String], input:String) -> [String]{
        return tickers.filter{ (ticker:String) in ticker.lowercaseString.containsString(input.lowercaseString)}
    }
}
