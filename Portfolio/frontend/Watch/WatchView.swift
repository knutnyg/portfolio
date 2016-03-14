
import Foundation
import UIKit
import SnapKit

class WatchView : UIViewController, AutocompleteViewDelegate, UITableViewDataSource, UITableViewDelegate {

    var controller:MyTabBarController!
    var watchList:UITableView!
    var autocompleteView:AutocompleteView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name:"StoreChanged", object:nil)

        controller = tabBarController as! MyTabBarController

        autocompleteView = AutocompleteView()
        autocompleteView.delegate = self
        autocompleteView.data = controller.store.allStockInfo.getTickersForAutocomplete()
        watchList = UITableView()
        watchList.dataSource = self
        watchList.delegate = self

//        button = createButton("To stock")
//        button.addTarget(self, action: "toStock:", forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(autocompleteView.view)
        view.addSubview(watchList)

        let comp = [
            ComponentWrapper(view: autocompleteView.view, rules: ConstraintRules(parentView: view).snapTop().marginTop(100).horizontalFullWithMargin(8).height(35)),
            ComponentWrapper(view: watchList, rules: ConstraintRules(parentView: view).marginTop(20).snapBottom().horizontalFullWithMargin(0).snapTop(autocompleteView.view.snp_bottom))
        ]

        SnapKitHelpers.setConstraints(comp)
    }

    func userSelectedItem(item:String){
        controller.store.addWatch(item)
    }

    public func reload(notification:NSNotification){
        watchList.reloadData()
    }

    func updateAutocompleteConstraints(rows:Int){
        let tableHeight = min(rows, 6)
        SnapKitHelpers.updateConstraints([
                ComponentWrapper(view: autocompleteView.view, rules: ConstraintRules(parentView: view).snapTop().marginTop(100).horizontalFullWithMargin(8).height(35 + 30*tableHeight))
        ])
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

}
