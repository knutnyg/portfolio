//
// Created by Knut Nygaard on 12/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation

class AutocompleteDataItem {
    let text:String!
    let detail:String!

    init(text:String, detail: String){
        self.text = text
        self.detail = detail
    }
}
