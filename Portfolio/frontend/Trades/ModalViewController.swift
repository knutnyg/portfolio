
import Foundation
import UIKit

class ModalViewController : UIViewController{

    var height:Int?
    var callback:(()->Void)?

    func cancel(){
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 0.0

        }, completion: dismiss)
    }

    func dismiss(bool:Bool) {
        self.dismissViewControllerAnimated(false, completion: callback)
    }

}
