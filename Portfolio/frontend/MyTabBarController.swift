
import Foundation
import UIKit
import BrightFutures

class MyTabBarController : UITabBarController {
    var store:Store!

    init(){
        super.init(nibName: nil, bundle: nil)
        store = Store(dataFile: "store_v6.dat")

        OsloBorsResource().allStockInformation(store).onSuccess{
            info in
            print("Got stockInfo!")
            self.store.allStockInfo = info
            self.store.allStockInfo.lastUpdated = NSDate()
            self.store.saveStore()
        }.onFailure{
            error in
            print("Failure from OsloStockResource")
        }
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init()
    }
}
