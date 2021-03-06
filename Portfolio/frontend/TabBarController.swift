
import Foundation
import UIKit
import BrightFutures

class TabBarController: UITabBarController {
    var store:Store!

    init(){
        super.init(nibName: nil, bundle: nil)
        store = Store(dataFile: "store_v11.dat")
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init()
    }
}
