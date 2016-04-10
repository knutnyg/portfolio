
import Foundation
import UIKit
import SnapKit
import MaterialKit
import BrightFutures
import Font_Awesome_Swift

class WatchView : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var controller:MyTabBarController!
    var watchList:UITableView!
    var newWatchButton:MKButton!
    var borsResource:OsloBorsResource!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name:"StoreChanged", object:nil)

        controller = tabBarController as! MyTabBarController
        borsResource = OsloBorsResource()

        let header = Header()
        .withTitle("Watches", color: UIColor.whiteColor(), font: nil)
        .withRightButtonIcon(FAType.FAPlus, action: toNewStock, color: UIColor.whiteColor())

        watchList = UITableView()
        watchList.dataSource = self
        watchList.delegate = self

        addChildViewController(header)

        view.addSubview(header.view)
        view.addSubview(watchList)

        let comp = [
            ComponentWrapper(view: header.view, rules: ConstraintRules(parentView: view).snapTop().horizontalFullWithMargin(0).height(60)),
            ComponentWrapper(view: watchList, rules: ConstraintRules(parentView: view).snapBottom().horizontalFullWithMargin(0).snapTop(header.view.snp_bottom))
        ]

        SnapKitHelpers.setConstraints(comp)

        updateAllStockMeta()
//        updateAllStockHistories()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateAllStockMeta()
    }

    func updateAllStockHistories(){
        let store = controller.store

        store.watchedStocks
        .map{borsResource.stockMetaInformation($0)}
        .sequence()
        .onSuccess{
            (stocks:[Stock]) in
            store.watchedStocks = stocks
            self.watchList.reloadData()
        }.onFailure{
            error in
            print(error)
        }
    }


    func updateAllStockMeta(){
        print("updating stocks meta")
        let store = controller.store

        store.watchedStocks
        .map{borsResource.stockMetaInformation($0)}
        .sequence()
        .onSuccess{
            (stocks:[Stock]) in
            store.watchedStocks = stocks
            self.watchList.reloadData()
        }.onFailure{
            error in
            print(error)
        }
    }

    public func reload(notification:NSNotification){
        watchList.reloadData()
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            tableView.beginUpdates()
            controller.store.removeWatch(controller.store.watchedStocks[indexPath.item])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.endUpdates()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let stock:Stock = controller.store.watchedStocks[indexPath.item]
        let cell = WatchTableViewCell(stock: stock)

        return cell;
    }

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.store.watchedStocks.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stockView = StockView(store: controller.store, stock: controller.store.watchedStocks[indexPath.item])
        stockView.callback = callback

        let vc = Modal(vc: stockView, callback: callback)
        vc.modalPresentationStyle = .OverCurrentContext

        presentViewController(vc, animated: false, completion: nil)
    }

    func toNewStock(){
        let autoCompleteView = AddWatch(title: "Legg til aksje", store: controller.store, callback: callback)

        let vc = Modal(vc: autoCompleteView, callback: callback)
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: false, completion: nil)
    }

    func callback() {
        updateAllStockMeta()
    }

}
