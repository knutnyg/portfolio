//
// Created by Knut Nygaard on 05/03/16.
// Copyright (c) 2016 Knut Nygaard. All rights reserved.
//

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
