
import Foundation
import UIKit
import SnapKit
import MaterialKit
import BrightFutures
import Font_Awesome_Swift

class WatchView : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var controller: TabBarController!
    var watchList:UITableView!
    var newWatchButton:MKButton!
    var borsResource:OsloBorsResource!
    var shouldRefresh = false
    var isRefreshing = false

    override func viewDidLoad() {
        super.viewDidLoad()

        controller = tabBarController as! TabBarController
        borsResource = OsloBorsResource()

        let header = Header()
        .withTitle("Watches", color: UIColor.whiteColor(), font: nil)
        .withRightButtonIcon(FAType.FAPlus, action: toNewWatch, color: UIColor.whiteColor())

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

        NSTimer.scheduledTimerWithTimeInterval(45, target: self, selector: #selector(timedReloadOfData), userInfo: nil, repeats: true)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shouldRefresh = true
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        shouldRefresh = false
    }

    func timedReloadOfData() {
        if shouldRefresh == true {
            isRefreshing = true
            updateAllStockMeta()
        }
    }

    func updateAllStockMeta(){
        let store = controller.store

        store.watchedStocks
        .map{borsResource.stockMetaInformation($0)}
        .sequence()
        .onSuccess{
            (stocks:[Stock]) in
            store.watchedStocks = stocks
            self.watchList.reloadData({ self.isRefreshing = false })
        }.onFailure{
            error in
            print(error)
        }
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

        if isRefreshing == true {
            cell.alpha = 0
            UIView.animateWithDuration(0.5, animations: { cell.alpha = 1 }, completion: nil)
        }

        return cell;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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

    func toNewWatch(){
        let autoCompleteView = AddWatch(store: controller.store, callback: callback)

        let vc = Modal(vc: autoCompleteView, callback: callback)
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: false, completion: nil)
    }

    func callback() {
        updateAllStockMeta()
    }

}
