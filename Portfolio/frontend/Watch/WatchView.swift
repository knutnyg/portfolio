
import Foundation
import UIKit
import SnapKit
import MaterialKit

class WatchView : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var controller:MyTabBarController!
    var watchList:UITableView!
    var newWatchButton:MKButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name:"StoreChanged", object:nil)
        view.backgroundColor = DARK_GREY

        controller = tabBarController as! MyTabBarController

        watchList = UITableView()
        watchList.dataSource = self
        watchList.delegate = self

        newWatchButton = MKButton()
        newWatchButton.backgroundColor = UIColor(hex: 0xFFC107)
        newWatchButton.cornerRadius = 30.0
        newWatchButton.elevation = 4.0
        newWatchButton.shadowOffset = CGSize(width: 0, height: 0)
        newWatchButton.setTitle("+", forState: .Normal)
        newWatchButton.addTarget(self, action: "toNewStock:", forControlEvents: .TouchUpInside)

        view.addSubview(watchList)
        view.addSubview(newWatchButton)


        let comp = [
            ComponentWrapper(view: watchList, rules: ConstraintRules(parentView: view).marginTop(60).snapBottom().horizontalFullWithMargin(0).snapTop()),
            ComponentWrapper(view: newWatchButton, rules: ConstraintRules(parentView: view).width(60).height(60).snapBottom().snapRight().marginBottom(60).marginRight(20))
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    public func reload(notification:NSNotification){
        watchList.reloadData()
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            controller.store.removeWatch(controller.store.watchedTickers[indexPath.item])
            tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = controller.store.watchedTickers[indexPath.item]
        return cell
    }


    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.store.watchedTickers.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = StockView(store: controller.store, stock: controller.store.stocks[controller.store.watchedTickers[indexPath.item]]!)
        presentViewController(vc, animated: false, completion: nil)
    }

    func toNewStock(sender:UIButton){
        let autoCompleteView = ModalAutocompleteView(title: "Legg til aksje", store: controller.store)

        let vc = Modal(vc: autoCompleteView)
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: false, completion: nil)
    }

}
