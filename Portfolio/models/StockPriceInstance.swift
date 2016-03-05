//
// Created by Knut Nygaard on 05/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

import Foundation

class StockPriceInstance {

    var stock:Stock!
    var date:NSDate!
    var price:Double!

    init(stock:Stock, date:NSDate, price:Double){
        self.stock = stock
        self.date = date
        self.price = price
    }

    init(csvRow:[String:String]){
        self.date = NSDate(dateString: csvRow["Date"]!)
        self.stock = Stock(ticker: "NAS.OL")
        self.price = Double(csvRow["Close"]!)
    }
}
//2004-01-12,30.00,31.40,30.00,31.40,155100,31.40