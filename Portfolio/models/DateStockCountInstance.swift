//
// Created by Knut Nygaard on 05/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation

class DateStockCountInstance {

    var date:NSDate!
    var stockOwned:StockOwned!

    init(date:NSDate, stockOwned:StockOwned){
        self.date = date
        self.stockOwned = stockOwned
    }

    func addStock(date:NSDate, count:Double){

    }

    func subtractStock(date:NSDate, count:Double){

    }
}
